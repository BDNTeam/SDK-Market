pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20Compatible.sol";


/**
 * @title BDNToken which is compatible with ERC Token Standard #20
 *
 * Symbol       :  BDN
 * Name         :  Business Data Network
 * Total supply :  1000000000.000000
 * Decimals     :  6
 *
 * (c) BDNTeam 2018. The MIT Licence.
 */
contract BDNToken is ERC20Compatible, Ownable {
  using SafeMath for uint256;

  string public name;
  string public symbol;
  uint8 public decimals;

  mapping(address => uint256) public balances;
  uint256 public totalSupply;

  constructor() public {
    name = "Business Data Network";
    symbol = "BDN";
    decimals = 6;
    totalSupply = 1000000000 * 10**uint(decimals);
    balances[owner] = totalSupply;
    emit Transfer(address(0), owner, totalSupply);
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0), "empty address");
    require(_value <= balances[msg.sender], "insufficient balance");

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
    require(_to != address(0), "empty address");
    require(_value <= balances[_from], "insufficient balance");

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }
}
