const { expect } = require("chai");

describe("ERC721 contract",()=>{
    let owners, acc1, acc2;
    let erc721Contract, deployedContract;
    describe("deployment verifaction",async ()=>{
        beforeEach(async ()=>{
            [owners, acc1, acc2] = await ethers.getSigners();
            erc721Contract = await ethers.getContractFactory('ATNFT');
            deployedContract = await erc721Contract.deploy();
        })
        
        it("at deployment verify name", async ()=>{
            const tokenName = await deployedContract.name();
            expect(tokenName).to.equal("Ayush Thakur");
        })
        it("at deployment verify symbol", async ()=>{
            const tokenSymbol = await deployedContract.symbol();
            expect(tokenSymbol).to.equal("ATNFT");
        })
    })

    describe("mint functionalities", async()=>{
        it('should fail if less than 0.5 eth provided', async()=>{
            await expect(
                deployedContract.mint("",{value: 1, gasLimit:1000000})
            ).to.be.revertedWith("0.5 eth is required to mint.");
           
        })
    })
})