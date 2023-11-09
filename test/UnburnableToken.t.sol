// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import { UnburnableToken } from "../src/UnburnableToken.sol";

contract UnburnableTokenTest is Test {
    UnburnableToken public unburnableToken;
    address public alice;
    address public bob;
    uint256 public aliceKeys = 0xA0A;
    uint256 public bobKeys = 0xB0B;

    function setUp() public {
        alice = address(0xA0A);
        bob = address(0xB0BBBBBBBBBBBBBBBBBBBBBBBBbbbbbbb);
        unburnableToken = new UnburnableToken();
        vm.deal(alice, 1 ether);
    }

    function testClaim() public {
        vm.startPrank(alice);
        unburnableToken.claim();
        assertEq(unburnableToken.balances(address(alice)), 1000);
    }

    function testFailClaim() public {
        unburnableToken.claim();
        assertEq(unburnableToken.balances(address(this)), 1000);
        unburnableToken.claim();
        vm.expectRevert();
    }

    function testSafeTransfer() public {
        unburnableToken.claim();
        unburnableToken.safeTransfer(alice, 1000);
        assertEq(unburnableToken.balances(address(this)), 0);
        assertEq(unburnableToken.balances(alice), 1000);
    }

    function testFailSafeTransfer() public {
        unburnableToken.claim();
        // should fail cant send to address(0)
        unburnableToken.safeTransfer(address(0), 1000);
        vm.expectRevert();
    }
    
    // test that safe treansfer fails if the balance if ether balance to sender is 0
    function testFailSafeTransfer2() public {
        unburnableToken.claim();
        unburnableToken.safeTransfer(address(bob), 500);
        assertEq(unburnableToken.balances(address(this)), 1000);
    }
}
