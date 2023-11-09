// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint private maxSupply;
    uint private constant USER_CLAIM_AMOUNT = 100;

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
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    enum Votes { FOR, AGAINST, ABSTAIN}
    Issue[] private issues;

    mapping (address => bool) private claimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    constructor() ERC20("NOTXYZ", "NXYZ") {
        maxSupply = 1000000;
        issues.push();
    }


    function claim() public {
        if (claimed[msg.sender]) revert TokensClaimed();
        if (totalSupply() == maxSupply) revert AllTokensClaimed();

        claimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(string memory _issueDesc, uint256 _quorum) external returns (uint id) {
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();
        if (_quorum > totalSupply()) revert QuorumTooHigh(_quorum);
        Issue storage issue = issues.push();
        issue.issueDesc = _issueDesc;
        issue.quorum = _quorum;
        return issues.length - 1;
    }
    
    function getIssue(uint _id) external view returns (IssueView memory issueView) {
        if (_id > issues.length) revert("Issue does not exist");
        Issue storage issue = issues[_id];
        return IssueView(
            issue.voters.values(),
            issue.issueDesc,
            issue.votesFor,
            issue.votesAgainst,
            issue.votesAbstain,
            issue.totalVotes,
            issue.quorum,
            issue.passed,
            issue.closed
        );
    }

    function vote(uint256 _issueId, Votes _vote) public {
        if (_issueId > issues.length) revert("Issue does not exist");
        Issue storage issue = issues[_issueId];
        if (issue.closed) revert VotingClosed();
        if (issue.voters.contains(msg.sender)) revert AlreadyVoted();
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();

        uint256 weight = balanceOf(msg.sender);
        (bool success) = issue.voters.add(msg.sender);
        if (!success) revert("Error adding voter");

        if (_vote == Votes.FOR) {
            issue.votesFor += weight;
        } else if (_vote == Votes.AGAINST) {
            issue.votesAgainst += weight;
        } else {
            issue.votesAbstain += weight;
        }
        issue.totalVotes += weight;
    
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }

}