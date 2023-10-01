// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Prime {
    function isPrime(uint num) public pure returns (bool) {
        if (num <= 1) {
            return false;
        }
        for (uint i = 2; i * i <= num; i++) {
            if (num % i == 0) {
                return false;
            }
        }
        return true;
    }
}
