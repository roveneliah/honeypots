// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "hardhat/console.sol";

/**
 * 
 * HONEYPOTS is a fractal, continuous token streaming
 * framework for funding teams within a DAO.
 * 
 * This v0 mints and distributes is own token; however,
 * in the future, HONEYPOTS will support the distribution
 * of any, and multiple, transferable tokens.
 * 
 * For instance, a HONEYPOT could simulateneously distribute
 * DAI, ETH, KRAUSE, and JERRY.
 * 
 **/
contract HONEYPOT {
    
    modifier admin() {
        require(admins[msg.sender]);
        _;
    }
    
    mapping (address => bool) admins;
    mapping (address => uint) votes;
    mapping (address => uint) availableVotes;
    mapping (address => mapping (address => uint)) userVotes;
    address[] teams;
    address[] public tokens;

    constructor() {
        admins[msg.sender] = true;
    }

    // updated votes don't count towards streams until createStreams is called
    function addVotes(address team, uint amount) admin public {
        require(availableVotes[msg.sender] >= amount);
        userVotes[msg.sender][team] += amount;
        availableVotes[msg.sender] -= amount;
    }
    
    function removeVotes(address team, uint amount) admin public {
        // make sure users votes for that team is gte {amount}
        require(userVotes[msg.sender][team] >= amount);
        userVotes[msg.sender][team] -= amount;
        availableVotes[msg.sender] += amount;
    }
    
    function transferVotes(address sender, address receiver, uint amount) admin external {
        removeVotes(sender, amount);
        addVotes(receiver, amount);
    }
    
    function payout() external {
        // checks if was already called today
        
        for (uint i = 0; i < teams.length; i++) {
            // pay out for each token
            
            
            
            // for (uint j = 0; j < tokens.length; j++) {
            //     // send each token asset
            //     Token token = Token(tokens[i]);
            //     uint tokenBalance = 
                
            //     // pay team proportional share of tokenBalance
            //     token.transfer(teams[i], tokenBalance * votes[teams[i]]);
            //     // MIGHT BE AN ISSUE IF BALANCE NOT DIVISIBLE
            // }
        }
        
        // gives a small percentage to whoever calls this (miner)
        // gives a small percentage to voters 
    }
    
    
    /**
     * Team Management
     * 
     * In order to receieve votes, a team must be added.
     * 
     * TODO:
     *  - decide who gets to add teams
     *  - decide who gets to remove teams
     * 
     * QUESTIONS:
     *  - can anyone add a team?
     *  - can anyone delete a team?
     * 
     **/
    function addTeam(address team) public {}
    function removeTeam(address team) public {}
    
    
    /**
     * 
     * BANK Functions
     * For adding new token types to this contract.
     * 
     * If people pay this contract directly, how will
     * the contract know how to send the token?  Needs to
     * know what/how the token works...
     * 
     * Or it could just ASSUME that each of its assets
     * 
     * 
     */
     
    /**
     * Adds an address of a token to try to send out.
     * Assumes token at this address has a f: transfer
     * 
     * MM: Vulnerability, what if that transfer function
     *      just is called "transfer", but then drains the contract?
     */
    function addToken(address tokenAddress) admin public{
        for (uint i = 0; i < tokens.length; i++) {
            if (tokens[i] == tokenAddress) return;
        }
        tokens.push(tokenAddress);
    }
    
    /**
     * Stops HONEYPOT from trying to send out this token,
     * even if it holds it here.
     * 
     * Returns true if popped, false if not present.
     */
    function removeToken(address tokenAddress) admin public{
        for (uint i = 0; i < tokens.length; i++) {
            if (tokens[i] == tokenAddress) {
                // swap-pop
                tokens[i] = tokens[tokens.length-1];
                tokens.pop();
            }
        }
    }




    //////////////////////////////////
    // HELPER FUNCTIONS FOR TESTING //
    //////////////////////////////////
    function tokensCount() public view returns (uint) {
        return tokens.length;
    }
}

// But how to trigger streams?
// Do we have someone programmatically calling `createStream`??
// Or can the contract do this automatically?
// Maybe we just reward the triggerer with some small KRAUSE amount similar to PoW