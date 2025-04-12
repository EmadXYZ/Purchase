// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Secure Purchase Agreement
/// @notice Implements a simple escrow contract between a buyer and a seller.
/// @dev Buyer deposits funds that are only released upon confirmation of delivery.
contract Purchase {
    uint256 public value; // Half of the initial deposit, used to enforce double deposit by buyer
    address payable public seller; // Seller's address
    address payable public buyer; // Buyer's address

    // Purchase lifecycle states
    enum State {
        Created, // Initial state after contract deployment
        Locked, // Purchase confirmed by buyer
        Release, // Item received by buyer
        Inactive // Contract finalized or aborted
    }

    State public state;

    /// @dev Ensures a condition is met before proceeding
    modifier condition(bool condition_) {
        require(condition_);
        _;
    }

    /// @dev Custom error for buyer-only functions
    error OnlyBuyer();

    /// @dev Custom error for seller-only functions
    error OnlySeller();

    /// @dev Custom error for incorrect state
    error InvalidState();

    /// @dev Custom error when initial value is not even
    error ValueNotEven();

    /// @dev Restricts access to the buyer only
    modifier onlyBuyer() {
        if (msg.sender != buyer) revert OnlyBuyer();
        _;
    }

    /// @dev Restricts access to the seller only
    modifier onlySeller() {
        if (msg.sender != seller) revert OnlySeller();
        _;
    }

    /// @dev Ensures function is only called in a specific state
    modifier inState(State state_) {
        if (state != state_) revert InvalidState();
        _;
    }

    // Events for UI and off-chain tracking
    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();

    /// @notice Deploy contract and lock in seller’s initial deposit
    /// @dev Requires that the sent value is an even number
    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
        if ((2 * value) != msg.value) revert ValueNotEven();
    }

    /// @notice Abort the purchase and reclaim funds
    /// @dev Only callable by seller in Created state
    function abort() external onlySeller inState(State.Created) {
        emit Aborted();
        state = State.Inactive;

        // Use call instead of transfer for better compatibility with zkSync
        (bool sent, ) = seller.call{value: address(this).balance}("");
        require(sent, "Abort transfer failed");
    }

    /// @notice Buyer confirms the purchase by depositing double the seller’s amount
    /// @dev Requires exact 2 * value; moves contract to Locked state
    function confirmPurchase()
        external
        payable
        inState(State.Created)
        condition(msg.value == (2 * value))
    {
        emit PurchaseConfirmed();
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    /// @notice Buyer confirms item was received
    /// @dev Releases buyer's deposit back to them; transitions to Release state
    function confirmReceived() external onlyBuyer inState(State.Locked) {
        emit ItemReceived();
        state = State.Release;

        // Use call instead of transfer for better compatibility with zkSync
        (bool sent, ) = buyer.call{value: value}("");
        require(sent, "Refund to buyer failed");
    }

    /// @notice Seller claims payment after buyer confirms delivery
    /// @dev Transfers total balance (3 * value) to seller and finalizes contract
    function refundSeller() external onlySeller inState(State.Release) {
        emit SellerRefunded();
        state = State.Inactive;

        // Use call instead of transfer for better compatibility with zkSync
        (bool sent, ) = seller.call{value: 3 * value}("");
        require(sent, "Refund to seller failed");
    }
}

    /*
    IlNlY3JldHMgc2hpbmUgbGlrZSBzdGFycyAg4oCUIGJ1dCBvbmx5IHRvIHRob3NlIHdo
    byBrbm93IGhvdyB0byBzZWUgaW4gdGhlIGRhcmsuIgrigJQgRW1hZCBTYWhlYmkg4pyo
    */
