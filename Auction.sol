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
}
