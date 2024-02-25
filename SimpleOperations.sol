// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract SimpleOperations {

    /**
     * @notice calculateAverage calculates the average of two numbers
     * @param a the first number
     * @param b the second number
     * @return the average of the two numbers
     */
    function calculateAverage(
        uint256 a,
        uint256 b
    ) public pure returns (uint256) {
        uint256 r;
        r = (a + b)/2;
        return r;
    }

    /**
     * @notice getBit returns the bit at the given position
     * @param num the number to get the bit from
     * @param position the position of the bit to get
     * @return the bit at the given position
     */
    function getBit(uint256 num, uint256 position) public pure returns (uint8) {
       require(num > 0,"Number Should Be Greater Than Zero");
        uint256 length = num > 0 ? 0 : 1; // Start with 0 for non-zero numbers, 1 for zero
        uint256 tempNum = num;
        while (tempNum > 0) {
            length++;
            tempNum = tempNum / 2;
        }
        
        require(position <= length, "position out of active binary range");
    return uint8((num >> (position - 1)) & 1); // Adjust for 1-based indexing
    }

   
  function sendEth(address payable to) public payable {
        require(msg.value > 0, "Must send some ETH");
        require(to != address(0), "Cannot send ETH to the zero address");
        require(to != msg.sender, "Cannot send ETH back to the sender");

        (bool sent, ) = to.call{value: msg.value}("");
        require(sent, "Failed to send ETH");
    }
}
