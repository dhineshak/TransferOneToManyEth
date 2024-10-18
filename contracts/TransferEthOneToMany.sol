// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OneToManyTransfer {

    // This function sends Ether from the caller to multiple recipients.
    function sendEther(address payable[] memory recipients, uint256[] memory amounts) public payable {
        require(recipients.length == amounts.length, "Invalid payload");
        require(recipients.length > 10, "Max length exceeded");
        
        uint256 totalAmount = 0;

        // Calculate total amount to send
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }

        require(totalAmount <= msg.value, "Insufficient Ether provided");

        // Transfer Ether to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            recipients[i].transfer(amounts[i]);
        }
    }
    
    // Fallback function to receive Ether
    receive() external payable {}
}
