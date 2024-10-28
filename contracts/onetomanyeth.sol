// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

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

    // Function to transfer ERC-20 tokens from sender to multiple recipients
    function sendTokens(address _sender, address tokenAddress, address[] memory recipients, uint256[] memory amounts) external {
        require(recipients.length == amounts.length, "Invalid payload");
        require(recipients.length <= 10, "Max length exceeded");

        IERC20 token = IERC20(tokenAddress); // Initialize the ERC-20 token interface

        for (uint256 i = 0; i < amounts.length; i++) {
            require(_sender != recipients[i], "Sender cannot receive"); // Ensure sender is not receiving tokens
            require(token.transferFrom(_sender, recipients[i], amounts[i]), "Token transfer failed"); // Transfer the tokens
        }
    }
    
    // Fallback function to receive Ether
    receive() external payable {}
}