const { ethers } = require("hardhat");
async function main() {
    const ATNFT = await ethers.getContractFactory('ATNFT');
    const deployedATNFT = await ATNFT.deploy();
    console.log("deployed>>", deployedATNFT);
}

main()
.then(()=>{
    process.exit(1);
})
.catch((e)=>{
    console.log(e);
    process.exit(0);
})
//0xfF0825AC91A0352eCcD3B30E488032cf8D93fF73 wallet
//0xF14c542923146646d76D9b21b28488264F1a4265 contract
//0x37571b50a9732593532d971587d5bb5f65b25749cdde362e76693ace12702177 hash