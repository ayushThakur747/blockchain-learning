//SPDX-License-Identifier: UNLICENSED
pragma  solidity >=0.5.0 <0.9.0;

contract Token{
    string public name="Hardhat Token";
    string public symbol="HHT";
    uint public totalSupply = 1000;

    address public owner;

    mapping(address=>uint) balance;

    constructor(){
        balance[msg.sender] = totalSupply;
        owner=msg.sender;
    }
    
    function transfer(address to, uint amount) external{
        require(balance[msg.sender]>=amount, "Not enough balance");
        balance[msg.sender]-=amount;
        balance[to]+=amount;
    }

    function balanceOf(address account) external view returns(uint256){
        return balance[account];
    }
}