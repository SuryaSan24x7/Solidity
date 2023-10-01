// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Registration is Ownable {
    mapping(address => string) public addressToUsername;
    mapping(string => bool) public isUsernameTaken;
    
    event RegistrationCompleted(address indexed user, string username);
    
    modifier usernameNotTaken(string memory username) {
        require(!isUsernameTaken[username], "Username is already taken");
        _;
    }
    modifier addressNotTaken(){
    require(bytes(addressToUsername[msg.sender]).length == 0, "Address is already registered");
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner(),"Owner cannot register");
        _;
    }
    
    function register(string memory username) public usernameNotTaken(username) addressNotTaken notOwner{
        address sender = msg.sender;
        addressToUsername[sender] = username;
        isUsernameTaken[username] = true;
        emit RegistrationCompleted(sender, username);
    }
    
    function changeUsername(string memory newUsername) public usernameNotTaken(newUsername) {
        address sender = msg.sender;
        string memory oldUsername = addressToUsername[sender];
        isUsernameTaken[oldUsername] = false;
        addressToUsername[sender] = newUsername;
        isUsernameTaken[newUsername] = true;
        emit RegistrationCompleted(sender, newUsername);
    }
}
