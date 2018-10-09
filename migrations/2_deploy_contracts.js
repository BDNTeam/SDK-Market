var BDNToken = artifacts.require("BDNToken.sol");
var Market = artifacts.require("Market.sol");

module.exports = function(deployer) {
  deployer.deploy(BDNToken).then(() => {
    return deployer.deploy(Market, BDNToken.address);
  });
};
