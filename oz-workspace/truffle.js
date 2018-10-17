require('dotenv').config();
const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');

/*var ropstenPrivateKey = new Buffer("2355aea4ab7bfbd1f3b6118e9c8c287830ea9137beaabe31c1b739c80827353f", "hex")
var ropstenWallet = Wallet.fromPrivateKey(ropstenPrivateKey);
var ropstenProvider = new WalletProvider(ropstenWallet, "https://ropsten.infura.io/");/*

/*var mordenPrivateKey = new Buffer("6c725eb394d7daf112407ad2e9e836d6101d48bede51edfa4c463011cfa38b56", "hex")
var mordenWallet = Wallet.fromPrivateKey(mordenPrivateKey);
var mordenProvider = new WalletProvider(mordenWallet, "http://35.237.10.166:8545");
*/


var mordenPrivateKey = new Buffer("597fa9a072722ddb9486a887e0880736e28b908d7c32fc632fdd52ab0ab1ceb0", "hex")

// ADDRESS: 0x9965e4d71edbe4093fc9686778fe1c661c02b30a
// PRIVATE KEY: 0xf10b3db841108a3940c71860d832654d6ef9d873200c7ee9584ab620422341ed
var mordenPrivateKey = new Buffer("f10b3db841108a3940c71860d832654d6ef9d873200c7ee9584ab620422341ed", "hex")
var mordenWallet = Wallet.fromPrivateKey(mordenPrivateKey);
var mordenProvider = new WalletProvider(mordenWallet, "https://web3.gastracker.io/morden");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    /*ropsten: {
      provider: ropstenProvider,
      // You can get the current gasLimit by running
      // truffle deploy --network rinkeby
      // truffle(rinkeby)> web3.eth.getBlock("pending", (error, result) =>
      //   console.log(result.gasLimit))
      //gas: 4600000000,
      gasPrice: web3.toWei("20", "gwei"),
      network_id: "3",
    },*/
    morden: {
      provider: mordenProvider,
      // You can get the current gasLimit by running
      // truffle deploy --network rinkeby
      // truffle(rinkeby)> web3.eth.getBlock("pending", (error, result) =>
      //   console.log(result.gasLimit))
      //gas: 4712388,
      //gasPrice: web3.toWei("20", "gwei"),
      network_id: "2",
    },
  }
};
