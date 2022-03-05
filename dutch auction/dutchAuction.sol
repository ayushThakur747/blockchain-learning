// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

interface IERC721{
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction{
    uint private constant duration = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable discountRate;
    uint public immutable startAt;
    uint public immutable expiresAt;

    constructor(address _nft, uint _nftId, address _seller, uint _startingPrice, uint _discountRate){
    
        seller = payable(_seller);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + duration;
        require(_startingPrice>=_discountRate*duration,"starting price is less than discount");

        nft = IERC721(_nft);
        nftId = _nftId;

    }    

    function getPrice() public view returns(uint){
        //require(block.timestamp<expiresAt, "auction expired");
        uint discount = (block.timestamp - startAt)*discountRate;
        return (startingPrice - discount);
    }

    function buy() external payable{
        require(block.timestamp<expiresAt, "auction expired");
        uint currentPrice = getPrice();
        require(msg.value>=currentPrice,"eth < price of the nft");

        nft.transferFrom(seller, msg.sender, nftId);
        
        uint refund = msg.value - currentPrice;
        if(refund>0){
            payable(msg.sender).transfer(refund);
        }

        selfdestruct(seller);

    }


}