require("@nomiclabs/hardhat-waffle"); //add this before testing with hardhat, mentioned in official doc
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const ALCHEMY_API_KEY = "8WVGTcKiwawtI8D__Me5F1D3g48kGDTu"; //what is this??
const ROPSTEN_PRIVATE_KEY =
  "16e051bcf57cf3cafe18c989a2b73bf4764b57fde56f54e7d190d7778b1f2f08";
module.exports = {
  solidity: "0.8.1",
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${ROPSTEN_PRIVATE_KEY}`],
    },
  },
};
