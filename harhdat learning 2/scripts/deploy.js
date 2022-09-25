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
//0x5f825685b2C3E1980fAea7E468d1F555022F458d