pragma solidity ^0.4.18;

import './ERC865Token.sol';

contract BRLTToken is ERC865Token {
  string public name = 'BRLT';
  string public symbol = 'BRLT';
  uint8 public decimals = 18;
  uint public INITIAL_SUPPLY = 0;

  constructor() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}
