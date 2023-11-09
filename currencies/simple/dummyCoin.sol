// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DummyCoin {
    // The keyword "public" makes variables accessible from other contracts
    mapping (address => uint256) public balances;

    // Events allow clients to react to specific contract changes you declare
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Constructor code is only run when the contract is created
    constructor(uint256 initialSupply) {
        // Give the creator all initial tokens
        balances[msg.sender] = initialSupply;
    }

    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint256 amount) public {
        require(msg.sender == address(this), "Only the contract itself can mint new coins.");
        require(amount < 1e60, "Maximum issuance exceeded");
        balances[receiver] += amount;
    }

    // Sends an amount of existing coins
    // from any caller to an address
    function transfer(address receiver, uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
    }

    // Read-only function to retrieve the balance of a given address
    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }
}
