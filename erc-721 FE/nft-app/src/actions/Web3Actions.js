import { useEffect } from "react";
import web3 from "../web3";

//functions to check - wallet available,network id, user address ,main balance

//check wallet available
export const checkWalletAvailable = () => {
  if (typeof window.ethereum !== "undefined" && window.ethereum.isMetaMask) {
    console.log(typeof window.ethereum, window.ethereum.isMetaMask);

    return true;
  } else {
    return false;
  }
};

//check network ID
export const checkCorrectNetwork = async () => {
  const chainID = await web3.eth.getChainId();
  return chainID;
};

//Get User address from web3
export const getUserAddress = async () => {
  const accounts = await window.ethereum.request({
    method: "eth_requestAccounts",
  });
  const accountAddress = accounts[0];
  return accountAddress;
};

// Get main token balance
export const getMainBalance = async () => {
  const address = await getUserAddress();
  const balance = await web3.eth.getBalance(address);
  const balanceInEth = web3.utils.fromWei(balance);
  return balanceInEth;
};
