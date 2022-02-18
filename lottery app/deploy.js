const HDWalletProvider = require("truffle-hdwallet-provider");
const Web3 = require("web3");
const { interface, bytecode } = require("./compile");
const provider = new HDWalletProvider(
  "horn sister pony master canoe cool speak omit trim pull distance dice",
  "https://mainnet.infura.io/v3/7b05ff2186554359ae6d0570ff117028"
);
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  console.log("accounts>>", accounts);
  console.log("interface", interface);
  const result = await new web3.eth.Contract(interface)
    .deploy({ data: bytecode })
    .send({ gas: web3.fromWei(1000000, 'ether'), from: accounts[0] });

  console.log("result>>", result.options.address);
};
deploy();
