// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Auth {
    // Struct to store user details
    struct User {
        bool registered;
        bool loggedIn;
        string username;
        string password;
    }

    // Mapping to store user details
    mapping(address => User) private users;

    // Event to emit when a user registers
    event Registered(address user, string username);

    // Event to emit when a user logs in
    event LoggedIn(address user);

    // Event to emit when a user logs out
    event LoggedOut(address user);

    // Function to register a user
    function register(string memory _username, string memory _password) public {
        address user = msg.sender;
        // Check if user is already registered
        require(!users[user].registered, "User already registered");
        // Register the user
        users[user].registered = true;
        users[user].username = _username;
        users[user].password = _password;
        emit Registered(user, _username);
    }

    // Function to login a registered user
    function login(string memory _username, string memory _password) public {
        address user = msg.sender;
        // Check if user is registered
        require(users[user].registered, "User not registered");
        // Check if user is already logged in
        require(!users[user].loggedIn, "User already logged in");
        // Check if provided username and password match
        require(
            keccak256(bytes(users[user].username)) == keccak256(bytes(_username)) &&
            keccak256(bytes(users[user].password)) == keccak256(bytes(_password)),
            "Invalid username or password"
        );
        // Login the user
        users[user].loggedIn = true;
        emit LoggedIn(user);
    }

    // Function to logout a logged-in user
    function logout() public {
        address user = msg.sender;
        // Check if user is logged in
        require(users[user].loggedIn, "User not logged in");
        // Logout the user
        users[user].loggedIn = false;
        emit LoggedOut(user);
    }
}
