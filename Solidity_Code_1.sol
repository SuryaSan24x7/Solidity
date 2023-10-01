// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.20;

contract Program1
{
    // Define a mapping to store mathematical operations
    mapping(uint8 => function(uint256, uint256) pure returns (uint256)) operations;

    // Constructor to initialize the mapping
    constructor() {
        // Add operation (1)
        operations[1] = add;

        // Subtract operation (2)
        operations[2] = sub;

        // Multiply operation (3)
        operations[3] = mul;

        // Divide operation (4)
        operations[4] = div;
        
        // Square operation (5)
        operations[5] = power;
    }

    // Function to perform addition
    function add(uint256 a, uint256 b) pure public returns (uint256) {
        return a + b;
    }

    // Function to perform subtraction
    function sub(uint256 a, uint256 b) pure public returns (uint256) {
        require(a >= b, "Subtraction underflow");
        return a - b;
    }

    // Function to perform multiplication
    function mul(uint256 a, uint256 b) pure public returns (uint256) {
        return a * b;
    }

    // Function to perform division
    function div(uint256 a, uint256 b) pure public returns (uint256) {
        require(b != 0, "Division by zero");
        return a / b;
    }
    // Function to perform Power
    function power(uint256 a,uint p) pure public returns (uint256) {
        require(p <= 0,"Enter a valid Power ");
         uint256 result = 1;

    for (uint256 i = 1; i <= p; i++) {
        result = result * a;
    }

    return result;
    }
}
