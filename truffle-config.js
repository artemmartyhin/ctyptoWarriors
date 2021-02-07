
require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     
      port: process.env.GANACHE_PORT, 
      network_id: "*", 
    },
    ropsten: {
      provider: () => new HDWalletProvider(
        process.env.ROPSTEN_PRIVATE_KEY,
        `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`
      ),
      network_id: 3,
      gas: 7500000,
      gasPrice: 10000000000
    },
    rinkeby: {
      provider: () => new HDWalletProvider(
        process.env.RINKEBY_PRIVATE_KEY,
        `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`
      ),
      network_id: 4,  
      gas: 9000000,
      gasPrice: 10000000000
    },
    kovan: {
      provider: () => new HDWalletProvider(
        process.env.KOVAN_PRIVATE_KEY,
        `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`
      ),
      network_id: 42, 
      gas: 12000000,
      gasPrice: 10000000000,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200
    },
    main: {
      provider: () => new HDWalletProvider(
        process.env.MAINNET_PRIVATE_KEY,
        `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`
      ),
      network_id: 1,
      gas: 12000000,
      gasPrice: 10000000000
    }
  },

  plugins: ["solidity-coverage", "truffle-contract-size"],
  mocha: {
    timeout: 25000
  },

  compilers: {
    solc: {
      version: "0.7.4", 
    }
  }
}