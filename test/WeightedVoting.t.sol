// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import { WeightedVoting } from "../src/WeightedVoting.sol";

contract WeightedVotingTest is Test {
    WeightedVoting public weightedVoting;
    address public alice;
    address public bob;
    address public carol;
    address public dave;
    address public eve;
    address public frank;
    address public george;
    address public harry;

    function setUp() public {
        alice = address(0xA1CE);
        bob = address(0xB0B);
        carol = address(0xC0C0);
        dave = address(0xD07E);
        eve = address(0xE3E3);
        frank = address(0xF0F);
        george = address(0x600D);
        harry = address(0x1DA7);

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
        vm.deal(carol, 10 ether);
        vm.deal(dave, 10 ether);
        vm.deal(eve, 10 ether);
        vm.deal(frank, 10 ether);
        vm.deal(george, 10 ether);
        vm.deal(harry, 10 ether);
        
        weightedVoting = new WeightedVoting();
    }

    function testConstructor() public {
        assertEq(weightedVoting.name(), "NOTXYZ");
        assertEq(weightedVoting.symbol(), "NXYZ");
        assertEq(weightedVoting.decimals(), 18);
        assertEq(weightedVoting.totalSupply(), 0);
    }

    // @notice test that a user can claim their tokens
    function testCanClaim() public {
        vm.startPrank(alice);
            weightedVoting.claim();
        vm.stopPrank();

        vm.startPrank(bob);
            weightedVoting.claim();
        vm.stopPrank();

        assertEq(weightedVoting.balanceOf(alice), 100 );
        assertEq(weightedVoting.balanceOf(bob), 100 );
        assertEq(weightedVoting.totalSupply(), 200 );
    }

    // @notice test that a user cannot claim twice
    function testFailCannotClaimTwice() public {
        vm.startPrank(alice);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(alice), 100 );
            weightedVoting.claim();
            vm.expectRevert("TokensClaimed()");
        vm.stopPrank();
    }

    // @notice test create a issue
    function testCreateIssue() public {
        vm.startPrank(alice);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(alice), 100 );
            uint256 issueId = weightedVoting.createIssue("test issue", 10 );
            // issueId should be 1 because the zero index is burned
            assertEq(issueId, 1);
        vm.stopPrank();

        WeightedVoting.IssueView  memory issue = weightedVoting.getIssue(issueId);
        assertEq(issue.issueDesc, "test issue");
        assertEq(issue.quorum, 10 );
        assertEq(issue.closed, false);
    }

    // @notice test that a user cannot create an issue if they do not have tokens
    function testFailCreateIssueNoTokens() public {
        vm.startPrank(alice);
            uint256 issueId = weightedVoting.createIssue("test issue", 10 );
            vm.expectRevert("NoTokensHeld()");
        vm.stopPrank();
    }

    // @notice test that a user cannot create an issue if the quorum is greater than the total supply
    function testFailCreateIssueQuorumGreaterThanTotalSupply() public {
        vm.startPrank(alice);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(alice), 100 );
            uint256 issueId = weightedVoting.createIssue("test issue", 101);
            vm.expectRevert();
        vm.stopPrank();
    }

    // @notice test that a user can vote on an issue
    function testVote() public {
        vm.startPrank(bob);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(bob), 100 );
        vm.stopPrank();

        vm.startPrank(carol);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(carol), 100 );
        vm.stopPrank();

        vm.startPrank(dave);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(dave), 100 );
        vm.stopPrank();

        vm.startPrank(alice);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(alice), 100 );
            uint256 issueId = weightedVoting.createIssue("test issue", 400 );
            weightedVoting.vote(issueId, WeightedVoting.Votes.FOR);
        vm.stopPrank();

        WeightedVoting.IssueView  memory issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 100 );  
        assertEq(issue.votesAgainst, 0);
        assertEq(issue.votesAbstain, 0);
        assertEq(issue.totalVotes, 100 );
        assertEq(issue.closed, false);


        vm.startPrank(bob);
            weightedVoting.vote(issueId, WeightedVoting.Votes.FOR);
        vm.stopPrank();
        issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 200 );
        assertEq(issue.votesAgainst, 0);
        assertEq(issue.votesAbstain, 0);
        assertEq(issue.totalVotes, 200 );
        assertEq(issue.closed, false);

        vm.startPrank(carol);
            weightedVoting.vote(issueId, WeightedVoting.Votes.AGAINST);
        vm.stopPrank();
        issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 200 );
        assertEq(issue.votesAgainst, 100 );
        assertEq(issue.votesAbstain, 0);
        assertEq(issue.totalVotes, 300 );
        assertEq(issue.closed, false);

        vm.startPrank(dave);
            weightedVoting.vote(issueId, WeightedVoting.Votes.ABSTAIN);
        vm.stopPrank();
        issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 200 );
        assertEq(issue.votesAgainst, 100 );
        assertEq(issue.votesAbstain, 100 );
        assertEq(issue.totalVotes, 400 );
        assertEq(issue.closed, true);
        assertEq(issue.passed, true);        
    }

    function testVoteAgainst() public {
        vm.startPrank(bob);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(bob), 100 );
        vm.stopPrank();

        vm.startPrank(carol);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(carol), 100 );
        vm.stopPrank();

        vm.startPrank(dave);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(dave), 100 );
        vm.stopPrank();

        vm.startPrank(alice);
            weightedVoting.claim();
            assertEq(weightedVoting.balanceOf(alice), 100 );
            uint256 issueId = weightedVoting.createIssue("test issue", 400 );
            weightedVoting.vote(issueId, WeightedVoting.Votes.AGAINST);
        vm.stopPrank();

        WeightedVoting.IssueView  memory issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 0);  
        assertEq(issue.votesAgainst, 100 );
        assertEq(issue.votesAbstain, 0);
        assertEq(issue.totalVotes, 100 );
        assertEq(issue.closed, false);

        vm.startPrank(bob);
            weightedVoting.vote(issueId, WeightedVoting.Votes.AGAINST);
        vm.stopPrank();
        issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 0);
        assertEq(issue.votesAgainst, 200 );
        assertEq(issue.votesAbstain, 0);
        assertEq(issue.totalVotes, 200 );
        assertEq(issue.closed, false);

        vm.startPrank(carol);
            weightedVoting.vote(issueId, WeightedVoting.Votes.FOR);
        vm.stopPrank();
        issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 100 );
        assertEq(issue.votesAgainst, 200 );
        assertEq(issue.votesAbstain, 0);
        assertEq(issue.totalVotes, 300 );
        assertEq(issue.closed, false);

        vm.startPrank(dave);
            weightedVoting.vote(issueId, WeightedVoting.Votes.ABSTAIN);
        vm.stopPrank();
        issue = weightedVoting.getIssue(issueId);
        assertEq(issue.votesFor, 100 );
        assertEq(issue.votesAgainst, 200 );
        assertEq(issue.votesAbstain, 100 );
        assertEq(issue.totalVotes, 400 );
        assertEq(issue.closed, true);
        assertEq(issue.passed, false);
    }


}
