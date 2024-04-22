// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimplePaymentChannel {
    address public owner;
    address public recipient;
    uint256 private balance;
    uint256[] private payments;

    // Event declarations for better monitoring of the contract's interactions
    event DepositMade(address indexed from, uint256 amount);
    event PaymentListed(uint256 amount);
    event ChannelClosed(address indexed closedBy, uint256 refundAmount);
    event FundsTransferred(address to, uint256 amount);

    modifier onlyParticipant() {
        require(msg.sender == owner || msg.sender == recipient, "Caller is not a participant");
        _;
    }

    constructor(address recipientAddress) {
        require(recipientAddress != address(0), "Recipient address cannot be the zero address");
        owner = msg.sender;
        recipient = recipientAddress;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balance += msg.value;
        emit DepositMade(msg.sender, msg.value);
    }

    function listPayment(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can list a payment");
        require(amount <= balance, "Amount exceeds available balance");
        balance -= amount;
        payments.push(amount);
        emit PaymentListed(amount);
    }

    function closeChannel() public onlyParticipant {
        if (msg.sender == owner) {
            payable(owner).transfer(balance);
            emit ChannelClosed(owner, balance);
        } else {
            for (uint256 i = 0; i < payments.length; i++) {
                payable(recipient).transfer(payments[i]);
                emit FundsTransferred(recipient, payments[i]);
            }
            if (balance > 0) {
                payable(owner).transfer(balance);
                emit ChannelClosed(owner, balance);
            }
        }
        balance = 0; // Ensures the channel is fully closed
        delete payments; // Clears the payment history
    }

    function checkBalance() public view returns (uint256) {
        return balance;
    }

    function getAllPayments() public view returns (uint256[] memory) {
        return payments;
    }
}
