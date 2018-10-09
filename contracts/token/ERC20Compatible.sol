pragma solidity ^0.4.24;


/// @title ERC Token Standard #20 Interface
/// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
contract ERC20Compatible {

  function name() public view returns (string);
  function symbol() public view returns (string);
  function decimals() public view returns (uint8);
  function totalSupply() public view returns (uint256);
  function balanceOf(address _owner) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
  function approve(address _spender, uint256 _value) public returns (bool);
  function allowance(address _owner, address _spender) public view returns (uint256);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
