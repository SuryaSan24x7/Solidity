// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StorageContract {

    // Function to store a new value
    uint val;
    function storeValue(uint256 _newValue) public {
        val = _newValue;
    }

    // Function to read the stored value
    function readValue() public view returns (uint256) {
       return val;
    }
}
