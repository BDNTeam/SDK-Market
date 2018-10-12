pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Asset.sol";
import "../token/EIP20Interface.sol";

contract Market is Ownable {

  EIP20Interface bdn;

  address[] public assets;
  mapping(address => uint) public assetIndexes;

  event NewAsset(address mktId, string asset, address seller, uint price);

  constructor(address _bdn) public {
    bdn = EIP20Interface(_bdn);
  }

  function sell(string cdbAddress, string boxAddress, string asset, uint price) public {
    Asset asset_ = new Asset(bdn, owner, msg.sender, cdbAddress, boxAddress, asset, price);
    assets.push(asset_);
    assetIndexes[address(asset_)] = 1;

    emit NewAsset(address(asset_), asset, msg.sender, price);
  }
}
