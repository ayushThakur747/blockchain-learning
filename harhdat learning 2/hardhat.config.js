/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();
require("@nomiclabs/hardhat-ethers"); 
require("@nomicfoundation/hardhat-chai-matchers");

module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "localhost",
  networks:{
    hardhat: {},
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/5Qf16vvIx1rVjIqwAFrxFsWRv8OLlwaf", //process.env.API_URL,
      accounts: ["0xe48322d51cafec336445fe8fd8480d830279430723888d54de60b6c34078404d"]//[`0x${process.env.PRIVATE_KEY}`]
    }
  }
};
