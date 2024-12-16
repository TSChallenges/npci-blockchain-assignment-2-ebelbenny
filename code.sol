// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvancedBank {
    address public owner; // The owner of the contract
    mapping(address => uint256) private balances; // Stores user balances
    uint256 public interestRate; // Annual interest rate in percentage (e.g., 5 means 5%)

    // Constructor to initialize the owner
    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    // Modifier to restrict access to owner-only functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to deposit Ether into the bank
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value; // Update the balance for the sender
    }

    // Function to withdraw Ether from the bank
    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount; // Deduct the amount from the sender's balance
        payable(msg.sender).transfer(amount); // Transfer Ether to the sender
    }

    // Function to calculate interest for the caller
    function calculateInterest() public view returns (uint256) {
        return (balances[msg.sender] * interestRate) / 100; // Calculate interest based on balance and rate
    }

    // Function for the owner to set the interest rate
    function setInterestRate(uint256 rate) public onlyOwner {
        require(rate > 0 && rate <= 100, "Interest rate must be between 1 and 100%");
        interestRate = rate; // Update the interestRate variable
    }

    // Function for the owner to withdraw all funds (administrative purpose)
    function withdrawAll() public onlyOwner {
        uint256 contractBalance = address(this).balance; // Get the contract's total balance
        require(contractBalance > 0, "No funds available in the contract");

        payable(owner).transfer(contractBalance); // Transfer all Ether to the owner
    }

    // Function to check the balance of the caller
    function getBalance() public view returns (uint256) {
        return balances[msg.sender]; // Returns the balance of the caller
    }

    // Fallback function to handle direct Ether transfers
    receive() external payable {
        deposit(); // Call the deposit function when Ether is sent directly
    }
}
