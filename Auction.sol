// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    address payable public owner;
    address payable public highestBidder;
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public highestBindingBid;
    uint256 bidIncrement;
    string public ipfsHash;

    enum State {Started, Running, Ended, Cancelled}
    State public auctionState;

    mapping(address => uint256) public bids;

    constructor(){
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        /// @dev The endBlock is approximated by getting the amount of seconds in a week and then dividing it by the blocktime (15 seconds)
        endBlock = startBlock + ((60 * 60 * 24 * 7) / 15);
        bidIncrement = 100;
    }
}
