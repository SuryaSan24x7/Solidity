//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Problem2 {
    //Add First n values
    uint public sum;
    function add(uint n) public returns (uint){
        //Requires More Gas
        for(uint i=1;i<=n;i++){
            sum+=i;
        }
        return sum;}
        
    function add2(uint n) public returns (uint){
        //Requires Less Gas
        sum=(sum+n);
        return (sum*(n/2));}

    function addSeries(uint first_num,uint last_num,uint diff) public returns (uint){
       require(diff > 0, "Common difference must be greater than 0");
    uint n = ((last_num - first_num) / diff) + 1;
     if (n % 2 == 0) {
        // If there are an even number of terms, use the standard formula
        sum = (n / 2) * (2 * first_num + (n - 1) * diff);
    } else {
        // If there are an odd number of terms, calculate the middle term and adjust
        sum = ((n / 2)+1)*(first_num + (n - 1) * diff);
    }
    return sum;
    }
    
    }
