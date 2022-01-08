// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Auction contract.
 */
contract Auction {
    address payable public owner;
    address payable public highestBidder;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public highestBindingBid;
    uint256 private bidIncrement;
    string public ipfsHash;

    enum State {Started, Running, Ended, Cancelled}
    State public auctionState;

    mapping(address => uint256) public bids;

    constructor(){
        owner = payable(msg.sender);
        auctionState = State.Running;
        startTime = block.timestamp;
        // @dev The Auctions' end time is 1 week (604800 seconds) after it started.
        endTime = startTime + 604800;
        bidIncrement = 100;
    }

    /**
     * @notice Place a bid for the auction.
     */
    function placeBid() public payable {
        /// @dev Don't let owner bid so that it can't artificially increase the price.
        require(msg.sender != owner);
        /// @dev Check that the auction is active.
        require(block.number >= startTime);
        require(block.number <= endTime);
        require(auctionState == State.Running);

        require(msg.value >= bidIncrement);

        uint256 currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);

        bids[msg.sender] = currentBid;

        if (currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    /**
     * @dev Returns the minimum of two values.
     * @param x First value
     * @param y Second value
     * @return The minimum of the two values.
     */
    function min(uint256 x, uint256 y) private pure returns (uint256) {
        if (x <= y) {
            return x;
        }
        return y;
    }
}
