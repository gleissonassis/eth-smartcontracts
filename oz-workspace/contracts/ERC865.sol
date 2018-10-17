pragma solidity ^0.4.18;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

/**
 * @title ERC865Token Token
 *
 * ERC865Token allows users paying transfers in tokens instead of gas
 * https://github.com/ethereum/EIPs/issues/865
 *
 */

contract ERC865 is ERC20 {
    function transferPreSigned(
        bytes _signature,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);

    function burnPreSigned(
        bytes _signature,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);
}
