/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

const path = require("path");
const Web3 = require("web3");
const HDWalletProvider = require("truffle-hdwallet-provider");

const WalletProvider = require("truffle-wallet-provider");
const Wallet = require("ethereumjs-wallet");

const web3 = new Web3();
const mnemonic = "";

const rawMainPrivateKey = process.env["MAINNET_PRIVATE_KEY"];
const rawRinkebyPrivateKey = process.env["RINKEBY_PRIVATE_KEY"];

let mainNetProvider = null;
if (rawMainPrivateKey) {
  const mainNetPrivateKey = Buffer.from(rawMainPrivateKey, "hex");
  const mainNetWallet = Wallet.fromPrivateKey(mainNetPrivateKey);
  mainNetProvider = new WalletProvider(
    mainNetWallet,
    "https://mainnet.infura.io"
  );
}

let rinkebyProvider = null;
if (rawRinkebyPrivateKey) {
  const k = Buffer.from(rawRinkebyPrivateKey, "hex");
  const w = Wallet.fromPrivateKey(k);
  rinkebyProvider = new WalletProvider(
    w,
    "https://rinkeby.infura.io/v3/79ff972db7234f24ab24bfcf3ffdd802"
  );
}

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.resolve(
    __dirname,
    "../sdk-eth-server/src/contracts"
  ),
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    mainnet: {
      provider: mainNetProvider,
      gas: 4600000,
      gasPrice: web3.utils.toWei("2", "gwei"),
      network_id: "1"
    },
    rinkeby: {
      provider: rinkebyProvider,
      gas: 6700000,
      gasPrice: web3.utils.toWei("2", "gwei"),
      network_id: "*"
    }
  }
};
