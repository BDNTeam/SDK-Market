pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Asset.sol";
import "../token/BDNToken.sol";

contract Market is Ownable {

  BDNToken bdn;

  address[] public assets;
  mapping(address => uint) public assetIndexes;

  event NewAsset(string asset, address seller, uint price);

  constructor(address _bdn) public {
    bdn = BDNToken(_bdn);
  }

  function sell(string asset, uint price) public {
    Asset asset_ = new Asset(bdn, owner, msg.sender, asset, price);
    assets.push(asset_);
    assetIndexes[address(asset_)] = 1;

    emit NewAsset(asset, msg.sender, price);
  }
}
