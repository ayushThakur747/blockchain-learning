//this is generally because to create a local instance of our contract and use this in our react app, now we can use all the methods etc of contract in here
import web3 from "./web3";

const address = ""; //contract address

const abi = []; //contract abi

export default new web3.eth.Contract(abi, address); //local copy/instace of actuall deployed contract's
