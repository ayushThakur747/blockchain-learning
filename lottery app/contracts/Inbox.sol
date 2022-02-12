// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Lottery{
    address public manager;
    address[] public player;
    
    constructor () {
        manager = msg.sender;
    }

    function enter() payable public{
        require(msg.value > 0.01 ether);
        player.push(msg.sender);
    }

    function random() private view returns(uint){
     return uint( keccak256(abi.encodePacked(block.difficulty, block.timestamp, player)));
    }

    function pickWinner() public payable restricted  returns(address) {
        uint index = (random()%player.length);
        address winner = player[index];
        //winner.transfer();//send money to winner
       // winner.transfer(address(this).balance);
       payable(winner).transfer(address(this).balance);
        player = new address[](0);//reset contract
        return winner;
    }

    modifier restricted (){
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns(address[] memory){
        return player;
    }
    

}