// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityCounter {
    mapping(uint => uint) public counters;
    address public owner;
    
    event CounterIncremented(uint indexed announcementId, uint newCount);
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function incrementCounter(uint announcementId) public {
        require(announcementId > 0, "Announcement ID must be greater than 0");
        counters[announcementId]++;
        emit CounterIncremented(announcementId, counters[announcementId]);
    }

    function viewCounter(uint announcementId) public view returns(uint) {
        return counters[announcementId];
    }
}
