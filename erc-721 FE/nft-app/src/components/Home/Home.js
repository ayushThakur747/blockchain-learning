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
  const address = "0xF57D7b8fc5A36f9062c98f513BD69a454803B09d";
  const [walletData, setWalletData] = useState({
    wallet: false,
    chainId: "not found",
    address: "Unavailable",
    balance: "0",
  });

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

    console.log("walletdata>>> ", walletData.wallet);
    const totalSupply = await contract.methods.totalSupply().call(); //calling function on smart contract
    console.log("total supply>>>>>> ", totalSupply);
  }

  const mintNFT = () => {
    contract.methods
      .safeMint(walletData.address)
      .send({ from: walletData.address, value: "10000000000000001" }); //sending transaction on smart contract
    return;
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
            <button onClick={mintNFT}>Mint</button>
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
