const { expect } = require("chai");

describe("Token contract", function () {
  let hardhatToken, Token;
  let owner, user1, user2;
  beforeEach(async function () {
    //deploying
    console.log("ethers>>>>>>>>>", ethers);

    [owner, user1, user2] = await ethers.getSigners(); //ethers will provide us wallet address
    console.log("address>", owner);
    Token = await ethers.getContractFactory("Token"); //creating instance of Token contract,doubt??hpw we are getting that contract, prev we used interface and bytecode of contract and deployed that
    hardhatToken = await Token.deploy(); //harhat will deploy this contract
  });

  describe("deployment verification", function () {
    it("at deployment totalsupply should go to owner ", async function () {
      //test
      const ownerBalance = await hardhatToken.balanceOf(owner.address); //using deployed contract instance calling contract function
      console.log("owner address", owner.address);
      //testcase
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transfer Test", function () {
    it("Should fail to transfer (do not have enough balance)", async function () {
      await expect(
        hardhatToken.connect(user1).a(user2.address, "10000") //from user1 to user2, doubt?? how can we tranfer from user1 as we do not own it or we do?
      ).to.be.revertedWith("Not enough balance");
    });

    it("Should successfully transfer", async function () {
      await hardhatToken.transfer(user1.address, "10"); //from owner to user1

      expect(await hardhatToken.balanceOf(user1.address)).to.equal("10");
    });
  });
});
