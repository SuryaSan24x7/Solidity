// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LibraryGuard {
    address public owner;
    mapping(address => bool) public admins;
    mapping(address => uint256) public userRoles;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event UserRoleUpdated(address indexed user, uint256 role);

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true; // Owner is also an admin by default
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can call this function");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid new owner address");
        owner = _newOwner;
        emit OwnershipTransferred(msg.sender, _newOwner);
    }

    function addAdmin(address _admin) public onlyOwner {
        require(_admin != address(0), "Invalid admin address");
        admins[_admin] = true;
        emit AdminAdded(_admin);
    }

    function removeAdmin(address _admin) public onlyOwner {
        require(admins[_admin], "Address is not an admin");
        admins[_admin] = false;
        emit AdminRemoved(_admin);
    }

    function updateUserRole(address _user, uint256 _role) public onlyAdmin {
        require(_user != address(0), "Invalid user address");
        userRoles[_user] = _role;
        emit UserRoleUpdated(_user, _role);
    }

    function contractOwner() public view returns (address) {
        return owner;
    }

    function isAdmin(address _user) public view returns (bool) {
        return admins[_user];
    }

    function userRole(address _user) public view returns (uint) {
        return userRoles[_user];
    }
}
