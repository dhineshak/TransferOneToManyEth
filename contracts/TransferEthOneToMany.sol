// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OneToManyTransfer {

    function sendEther(address _sender, address[] memory recipients, uint256[] memory amounts) external payable {
        require(recipients.length == amounts.length, "Invalid payload");
        require(recipients.length <= 10, "Max length exceeded");
        
        for (uint256 i = 0; i < amounts.length; i++) {
            if(_sender != recipients[i]) { // Check that sender is not one of the receivers
                (bool success, ) = recipients[i].call{value: amounts[i]}(""); 
                require(success, "Transfer failed");
            }
        }
    }
    
    // Fallback function to receive Ether
    receive() external payable {}
}
