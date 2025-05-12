// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20; // Same Solidity version as the EtherVault

/**
 * @title SelfDestructSender
 * @dev A simple contract to receive Ether and then self-destruct, sending its balance
 * to a target address. Used for the EtherVault assignment self-destruct challenge.
 */
contract SelfDestructSender {
    // The address of the EtherVault contract where the Ether will be sent.
    address payable immutable etherVaultAddress;

    // The exact amount required by the EtherVault's self-destruct challenge.
    uint256 public constant REQUIRED_AMOUNT = 0.0005 ether;

    /**
     * @dev Constructor sets the target EtherVault address.
     * @param _etherVaultAddress The address of the deployed EtherVault contract.
     */
    constructor(address payable _etherVaultAddress) {
        require(_etherVaultAddress != address(0), "EtherVault address cannot be zero.");
        etherVaultAddress = _etherVaultAddress;
    }

    /**
     * @dev This function allows the contract to receive Ether.
     * It's triggered when Ether is sent to this contract's address
     * without calling a specific function.
     */
    receive() external payable {
        // No specific logic needed here for this assignment,
        // just needs to be payable to receive funds.
    }

    /**
     * @dev Triggers the self-destruct mechanism.
     * This sends the contract's entire balance to the etherVaultAddress
     * and removes the contract code from the blockchain (in pre-EIP-6780 behavior).
     * Includes the specific require check required by the assignment.
     *
     * NOTE: 'selfdestruct' is deprecated and its behavior changed with EIP-6780 (Cancun hard fork).
     * For new contracts deployed post-Cancun, it might not fully remove contract code/storage
     * unless created in the same transaction. However, this assignment specifically requires
     * using 'selfdestruct' with a particular error message, indicating it's testing
     * understanding of this concept as relevant to the challenge environment.
     * Therefore, we use 'selfdestruct' here as required by the assignment instructions.
     */
    function triggerSelfDestruct() external {
        // Check if the contract's current balance is EXACTLY the required amount.
        // This is the specific requirement for the assignment's challenge.
        require(address(this).balance == REQUIRED_AMOUNT, "Must send exactly 0.0005 ether");

        // Trigger self-destruct. The remaining balance is sent to the target address.
        // The contract code is removed from the blockchain (as expected by the assignment).
        selfdestruct(etherVaultAddress);
    }

    /**
     * @dev Optional: A function to check the contract's current balance.
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
