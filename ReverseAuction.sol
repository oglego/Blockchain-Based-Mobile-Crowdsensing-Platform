// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0 < 0.9.0;

contract RA {
    // Create a variable to store our task
    string task;
    // Create an array to store bidder's wallets in
    address[] bidders;
    // Create an array to store bid values in
    uint[] bids;
    // Create a value to be the minimum - note that
    // we are using a large value so that we can replace it
    // with the minimum bids
    uint min = 100000000000000000000000; // This is 100000 ethers in wei

    // Create an address variable for the crowdsensing platform
    address platform;

    // Create an enumeration of steps for the bidding process
    enum step {AdvertiseTask, SubmitBids, SelectWinner, EndAuction}
    // First step
    step public current = step.AdvertiseTask; 
    
    // Each step will be an event
    event AdvertiseTask();
    event SubmitBids();
    event SelectWinner();
    event EndAuction();

    // Make the Platform have the controls for the auction
    modifier onlyPlatform(){
        require(msg.sender == platform);
        _;
    }

    // Have the platform deploy the contract
    constructor() payable {
        platform = msg.sender; 
        // Start the auction by advertising the tasks
        emit AdvertiseTask();
    }
    
    // Only the platform can change which step of the
    // auction we are in
    function changeStep() public onlyPlatform {
        if (current == step.EndAuction) {
            current = step.AdvertiseTask;
        } else {
            uint next = uint(current) + 1;
            current = step(next);
        }
        if (current == step.AdvertiseTask) emit AdvertiseTask();
        if (current == step.SubmitBids) emit SubmitBids();
        if (current == step.SelectWinner) emit SelectWinner();
        if (current == step.EndAuction) emit EndAuction();
    }

    // Create a function that will allow the platform to
    // advertise their tasks - in this scenario there will
    // only be one task 
    function advertise() public onlyPlatform returns (string memory){
        task = "Task is T1";
        return task;
    }

    // Create a simple function for users to submit a bid
    // add the bid to the array bids
    // add the user's address to the bidder array
    // Check to see if the newly submitted bid is now the
    // minimum bid that has been submitted
    function submitBid (uint b) public {
        bids.push(b);
        bidders.push(msg.sender);
        if (b < min) {
            min = b;
        }
    }
    
    // Create a function that will show the bids 
    function getBids() public view onlyPlatform returns (uint[] memory) {
        return bids;
    }

    // Create a function that will show the wallet addresses
    // of the users who have submitted bids
    function getWallets() public view onlyPlatform returns (address[] memory){
        return bidders;
    }

    // Create a function that will find the user who has
    // submitted the lowest bid - this will be the winner
    // of the reverse auction after the auction has ended
    function getWinner() public view onlyPlatform returns (address,  uint) {
        // Create variables for the winner's wallet address
        // and a variable to hold the amount for the winning bid (min bid)
        address winnerWallet;
        uint winnerBid;
        // Iterate through the bids that have been submitted, if the
        // bid is equal to the minimum bid, then set our variables
        // to house the winner's address and their winning bid
        for(uint i = 0; i < bids.length; i++){
            if(bids[i] == min){
                winnerWallet = bidders[i];
                winnerBid = bids[i];
            }
        }
        // Return the winner's wallet address and their bid
        return (winnerWallet, winnerBid);
    }
}