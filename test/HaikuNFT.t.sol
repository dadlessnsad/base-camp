// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {HaikuNFT} from "../src/HaikuNFT.sol";

contract CounterTest is Test {
    HaikuNFT public haikuNFT;

    function setUp() public {
        haikuNFT = new HaikuNFT();
    }

    function testMintHaiku() public {
        haikuNFT.mintHaiku("line1", "line2", "line3");
    }

    function testShareHaiku() public {
        haikuNFT.mintHaiku("line1", "line2", "line3");
        haikuNFT.shareHaiku(1, address(this));
    }
    

}
