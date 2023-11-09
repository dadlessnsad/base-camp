// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct IssueView {
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    enum Votes {
        AGAINST,
        FOR,
        ABSTAIN
    }

    uint256 public constant maxSupply = 1_000_000;
    Issue[] issues;

    mapping(address => uint256) public balances;
    mapping(address => bool) public hasClaimed;

    // Constructor
    // Initialize the ERC-20 token and burn the zeroeth element of issues. 
    constructor() ERC20("WeightedVoting", "WV") {
        Issue storage zeroIssue = issues.push();
        zeroIssue.closed = true;
    }

    modifier onlyVoters() {
        if (balances[msg.sender] == 0) revert NoTokensHeld();
        _;
    }

    modifier onlyIfOpen(uint256 _issueId) {
        if (issues[_issueId].closed) revert VotingClosed();
        _;
    }


    // Claim
    // Add a public function called claim. When called, so long as a number of tokens equalling the maximumSupply have not yet been distributed, any wallet that has not made a claim previously should be able to claim 100 tokens. If a wallet tries to claim a second time, it should revert with TokensClaimed.
    // Once all tokens have been claimed, this function should revert with an error AllTokensClaimed.
    function claim() public {
        if (hasClaimed[msg.sender]) revert TokensClaimed();
        if (totalSupply() + 100 > maxSupply) revert AllTokensClaimed();
        hasClaimed[msg.sender] = true;
        balances[msg.sender] += 100;
        
        _mint(msg.sender, 100);
    }



    //     Create Issue
    // Implement an external function called createIssue. It should add a new Issue to issues, allowing the user to set the description of the issue, and quorum - which is how many votes are needed to close the issue.
    // Only token holders are allowed to create issues, and issues cannot be created that require a quorum greater than the current total number of tokens.
    // This function must return the index of the newly-created issue.
    function createIssue(string memory _issueDesc, uint256 _quorum) external onlyVoters returns (uint256) {
        if (_quorum > totalSupply()) revert QuorumTooHigh(_quorum);
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        return issues.length - 1;
    }


    // Get Issue
    // Add an external function called getIssue that can return all of the data for the issue of the provided _id.
    // EnumerableSet has a mapping underneath, so it can't be returned outside of the contract. You'll have to figure something else out.
    //The return type for this function should be a struct very similar to the one that stores the issues.
    function getIssue(uint256 _id) external view returns (IssueView memory) {
        return IssueView(
            issues[_id].issueDesc,
            issues[_id].votesFor,
            issues[_id].votesAgainst,
            issues[_id].votesAbstain,
            issues[_id].totalVotes,
            issues[_id].quorum,
            issues[_id].passed,
            issues[_id].closed
        );
    }

    //Vote
    // Add a public function called vote that accepts an _issueId and the token holder's vote. The function should revert if the issue is closed, or the wallet has already voted on this issue.
    // Holders must vote all of their tokens for, against, or abstaining from the issue. This amount should be added to the appropriate member of the issue and the total number of votes collected.
    // If this vote takes the total number of votes to or above the quorum for that vote, then:
    // The issue should be set so that closed is true
    // If there are more votes for than against, set passed to true
    function vote(uint256 _issueId, Votes _vote) public {
        Issue storage issue = issues[_issueId];
        
        if (issue.closed) revert VotingClosed();
        if (issue.voters.contains(msg.sender)) revert AlreadyVoted();
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();

        uint256 voterBalance = balanceOf(msg.sender);
        issue.voters.add(msg.sender);
        
        if (_vote == Votes.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Votes.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else {
            issue.votesAbstain += voterBalance;
        }

        issue.totalVotes += voterBalance;
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }

}
