// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdFund {
    struct Campaign {
        uint256 goal;
        uint256 endTime;
        uint256 totalFunds;
        address creator;
    }

    IERC20 public token;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;
    uint256 public nextCampaignId = 1;

    constructor(address _token) {
        require(_token != address(0), "Token address cannot be zero");
        token = IERC20(_token);
    }

    function createCampaign(uint256 goal, uint256 duration) external {
        require(goal > 0, "Goal must be greater than 0");
        require(duration > 0, "Duration must be greater than 0");

        campaigns[nextCampaignId] = Campaign({
            goal: goal,
            endTime: block.timestamp + duration,
            totalFunds: 0,
            creator: msg.sender
        });

        nextCampaignId++;
    }

    function contribute(uint256 id, uint256 amount) external {
        require(id > 0 && id < nextCampaignId, "Campaign does not exist");
        require(msg.sender != campaigns[id].creator, "Creator cannot contribute");
        require(block.timestamp < campaigns[id].endTime, "Campaign has ended");
        require(amount > 0, "Contribution must be greater than 0");

        token.transferFrom(msg.sender, address(this), amount);
        campaigns[id].totalFunds += amount;
        contributions[id][msg.sender] += amount;
    }

    function cancelContribution(uint256 id) external {
        require(contributions[id][msg.sender] > 0, "No contributions to cancel");
        require(block.timestamp < campaigns[id].endTime, "Campaign has ended");

        uint256 contributionAmount = contributions[id][msg.sender];
        contributions[id][msg.sender] = 0;
        campaigns[id].totalFunds -= contributionAmount;

        token.transfer(msg.sender, contributionAmount);
    }

    function withdrawFunds(uint256 id) external {
        require(msg.sender == campaigns[id].creator, "Only creator can withdraw");
        require(block.timestamp > campaigns[id].endTime, "Campaign is still active");
        require(campaigns[id].totalFunds >= campaigns[id].goal, "Goal not reached");

        uint256 amountToWithdraw = campaigns[id].totalFunds;
        campaigns[id].totalFunds = 0; // Prevent re-entrancy attacks
        token.transfer(msg.sender, amountToWithdraw);
    }

    function refund(uint256 id) external {
        require(contributions[id][msg.sender] > 0, "No contributions made");
        require(block.timestamp > campaigns[id].endTime, "Campaign is still active");
        require(campaigns[id].totalFunds < campaigns[id].goal, "Goal has been reached");

        uint256 refundAmount = contributions[id][msg.sender];
        contributions[id][msg.sender] = 0;
        token.transfer(msg.sender, refundAmount);
    }

    function getContribution(uint256 id, address contributor) public view returns (uint256) {
        return contributions[id][contributor];
    }

    function getCampaign(uint256 id) public view returns (uint256 remainingTime, uint256 goal, uint256 totalFunds) {
        require(id > 0 && id < nextCampaignId, "Campaign does not exist");
        Campaign storage campaign = campaigns[id];
        remainingTime = campaign.endTime > block.timestamp ? campaign.endTime - block.timestamp : 0;
        goal = campaign.goal;
        totalFunds = campaign.totalFunds;
    }
}
