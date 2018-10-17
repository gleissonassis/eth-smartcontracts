pragma solidity ^0.4.18;

import './ERC865.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol';

/**
 * @title ERC865Token Token
 *
 * ERC865Token allows users paying transfers in tokens instead of gas
 * https://github.com/ethereum/EIPs/issues/865
 *
 */

contract ERC865Token is ERC865, MintableToken, BurnableToken {


    /* Nonces of transfers performed */
    mapping(bytes => bool) signatures;

    event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
    event BurnPreSigned(address indexed from, address indexed delegate, uint256 amount, uint256 fee);
    event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);

    /**
     * @notice Submit a presigned transfer
     * @param _signature bytes The signature, issued by the owner.
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function transferPreSigned(
        bytes _signature,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(_to != address(0));
        require(signatures[_signature] == false);

        bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);

        address from = recover(hashedTx, _signature);
        require(from != address(0));

        balances[from] = balances[from].sub(_value).sub(_fee);
        balances[_to] = balances[_to].add(_value);
        balances[msg.sender] = balances[msg.sender].add(_fee);
        signatures[_signature] = true;

        emit Transfer(from, _to, _value);
        emit Transfer(from, msg.sender, _fee);
        emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
        return true;
    }

    /**
     * @notice Submit a presigned burn
     * @param _signature bytes The signature, issued by the owner.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function burnPreSigned(
        bytes _signature,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(signatures[_signature] == false);

        bytes32 hashedTx = burnPreSignedHashing(address(this), _value, _fee, _nonce);

        address from = recover(hashedTx, _signature);
        require(from != address(0));

        _burn(from, _value);

        balances[from] = balances[from].sub(_fee);
        balances[msg.sender] = balances[msg.sender].add(_fee);
        signatures[_signature] = true;

        emit Transfer(from, msg.sender, _fee);
        emit BurnPreSigned(from, msg.sender, _value, _fee);

        return true;
    }


    /**
     * @notice Hash (keccak256) of the payload used by transferPreSigned
     * @param _token address The address of the token.
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function transferPreSignedHashing(
        address _token,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce));
    }

    /**
     * @notice Hash (keccak256) of the payload used by burnPreSignedHashing
     * @param _token address The address of the token.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function burnPreSignedHashing(
        address _token,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "0x48664c17": burnPreSignedHashing(address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0x48664c17), _token, _value, _fee, _nonce));
    }

    /**
     * @notice Recover signer address from a message by using his signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param sig bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes sig) public pure returns (address) {
      bytes32 r;
      bytes32 s;
      uint8 v;

      //Check the signature length
      if (sig.length != 65) {
        return (address(0));
      }

      // Divide the signature in r, s and v variables
      assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := byte(0, mload(add(sig, 96)))
      }

      // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
      if (v < 27) {
        v += 27;
      }

      // If the version is correct return the signer address
      if (v != 27 && v != 28) {
        return (address(0));
      } else {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
        return ecrecover(prefixedHash, v, r, s);
      }
    }
}
