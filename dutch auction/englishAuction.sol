// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

interface IERC721{
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract EnglishAuction{
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event AuctionEnded(address highestBidder, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    address public highestBidder;
    uint public highestBid;
    uint32 public endAt;
    mapping(address=>uint) bids;//all the bids

    bool public isStarted;
    bool public isEnded;

    constructor(address _nft, uint _nftId,address _seller, uint _startingBid){
        seller = payable(_seller);
        nft = IERC721(_nft);
        highestBid = _startingBid;
        nftId = _nftId;
    }   

    function startAt() external {
        require(msg.sender == seller, "not seller");
        require(!isStarted,"already started");
        isStarted = true;
        endAt = uint32(block.timestamp + 60);
        nft.transferFrom(seller,address(this), nftId);
    }

    function bid() payable external {
        require(isStarted,"not started");
        require(!isEnded,"ended");
        require(msg.value>highestBid, "eth is < highest bid");

        if(highestBidder!=address(0)){
            bids[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender,msg.value);
    }

    function withdraw() external payable{
        require(isEnded,"not ended");
        
        uint value = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(value);

        emit Withdraw(msg.sender, msg.value);
    }

    function endAuction() external{
        require(isStarted,"not started yet");
        require(!isEnded,"already ended");
        require(block.timestamp>=endAt, "can't end now");
        
        isEnded = true;

        if(highestBidder != address(0)){
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        }else{
            nft.transferFrom(address(this), seller, nftId);
        }


        emit AuctionEnded(highestBidder,highestBid);
    }



}