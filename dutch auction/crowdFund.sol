// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./IERC20.sol";

contract CrowdFund{
    event Launch(uint id, address indexed creater, uint startAt, uint endAt);
    event Cancel(uint id);
    event Pledged(uint id, address indexed caller, uint amount);
    event Unpledged(uint id, address indexed caller, uint amount);
    event Claimend(uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);

    struct Campaign{
        address creater;
        uint goal;
        uint pledged;
        bool isClaimed;
        uint startAt;
        uint endAt;
    }

    IERC20 public immutable token;
    uint private count = 0;
    mapping(uint=>Campaign) public campaigns;
    mapping(uint=>mapping(address=>uint)) public pledgedAmount;

    constructor(address _token){
        token = IERC20(_token);
    }

    function launch(uint _startAt, uint _endAt, uint _goal) external{
        require(_startAt >=block.timestamp, "start at < now");
        require(_endAt >= _startAt," end at < start at");
        require(_endAt <= block.timestamp+90 days, "end at >max duration");

        count += 1;
        campaigns[count] = Campaign({
            creater:msg.sender,
            goal: _goal,
            pledged: 0,
            isClaimed: false,
            startAt: _startAt,
            endAt: _endAt
        });

        emit Launch(count, msg.sender, _startAt, _endAt);
    }

    function cancel(uint _id) external{
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creater,"not campaing creater");
        require(block.timestamp<campaign.startAt, "started");
        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(campaign.startAt < block.timestamp, "not started");
        require(campaign.endAt > block.timestamp, "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledged(_id, msg.sender, _amount);
    }

    function unpledged(uint _id, uint _amount) external{
          Campaign storage campaign = campaigns[_id];
          require(block.timestamp < campaign.endAt, "ended");
        //doubt: here should be one more require that check weather the sender pledged this much amount he is unpledging 
          campaign.pledged -= _amount;
          pledgedAmount[_id][msg.sender] -= _amount;
          token.transfer(msg.sender, _amount);

        emit Unpledged(_id,msg.sender, _amount);
    }  

    function  claim(uint _id) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp>campaign.startAt,"not started");
        require(block.timestamp>campaign.endAt,"not ended");
        require(msg.sender == campaign.creater,"not the creater");
        require(campaign.pledged>=campaign.goal,"pledged amount is less than goal");
        require(campaign.isClaimed == false, "already claimend");
        
        campaign.isClaimed = true;
        token.transfer( msg.sender, campaign.pledged);

        emit Claimend(_id);
    }

    function refund(uint _id) external{
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt ,"campaign not ended");
        require(campaign.pledged < campaign.goal, "pledged > goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender,bal);//doubt why transfer() token,

        emit Refund(_id, msg.sender, bal);
    }   

}
