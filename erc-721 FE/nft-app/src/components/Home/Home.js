import React, { useState, useEffect } from "react";
import { MyNFT_ABI } from "../../abi";
import {
  checkWalletAvailable,
  checkCorrectNetwork,
  getMainBalance,
  getUserAddress,
} from "../../actions/Web3Actions";
import web3 from "../../web3";
function Home() {
  const address = "0xaB16A056B7173aF14f3E086a8c64DBF72b1eb326";
  const [walletData, setWalletData] = useState({
    wallet: false,
    chainId: "not found",
    address: "Unavailable",
    balance: "0",
  });
  const [contractOwner, setContractOwner] = useState("");
  const [tokenURI, setTokenURI] = useState("");

  const contract = new web3.eth.Contract(MyNFT_ABI, address); //contract instance through web3

  async function connectWallet() {
    console.log("connect>>>>>>>");
    const wallet = checkWalletAvailable();
    const chainId = await checkCorrectNetwork();
    const address = await getUserAddress();
    const balance = await getMainBalance();

    setWalletData({
      wallet: wallet,
      chainId: chainId,
      address: address,
      balance: balance,
    });
    const owner = await contract.methods.owner().call();
    setContractOwner(owner);
    console.log("owner>>>>>>", owner, contractOwner);
    console.log("walletdata>>> ", walletData.wallet);
    const totalSupply = await contract.methods.totalSupply().call(); //calling function on smart contract
    console.log("total supply>>>>>> ", totalSupply);
  }

  const mintNFT = (e) => {
    e.preventDefault();
    console.log("mintnft>>>", walletData.address, tokenURI);
    contract.methods
      .safeMint(walletData.address, tokenURI)
      .send({ from: walletData.address, value: "10000000000000001" }); //sending transaction on smart contract
    return;
  };

  const withdrawContractFunds = async () => {
    contract.methods.withdraw().send({ from: walletData.address });
  };

  return (
    <div>
      <h1>Home</h1>
      {walletData.wallet ? (
        <div>
          <div>
            <h2>User detail</h2>
            <p>wallet: {walletData.wallet ? "available" : "not available"}</p>
            <p>chainID: {walletData.chainId}</p>
            <p>wallet address: {walletData.address}</p>
            <p>main balance: {walletData.balance}</p>
          </div>
          <div>
            <p>You can mint your own NFT here..</p>
            <form onSubmit={() => mintNFT()}>
              <input
                type="text"
                onChange={(e) => setTokenURI(e.target.value)}
                placeholder="URI"
              />
              <button onClick={(e) => mintNFT(e)}>Mint</button>
            </form>
          </div>
          <div>
            {walletData.address === contractOwner.toLocaleLowerCase() ? (
              <button onClick={() => withdrawContractFunds()}>withdraw</button>
            ) : null}
          </div>
        </div>
      ) : (
        <div>
          {" "}
          <p>connect wallet...</p>
          <button onClick={() => connectWallet()}>connect</button>{" "}
        </div>
      )}
    </div>
  );
}

export default Home;
