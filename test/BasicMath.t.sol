// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {BasicMath} from "../src/BasicMath.sol";

contract CounterTest is Test {
    BasicMath public basicMath;

    function setUp() public {
        basicMath = new BasicMath();
    }

    function test_Adder() public {
        (uint sum, bool error) = basicMath.adder(1, 2);
        assertEq(sum, 3);
        assertFalse(error);
    }

    function test_Subtractor() public {
        (uint difference, bool error) = basicMath.subtractor(2, 1);
        assertEq(difference, 1);
        assertFalse(error);
    }

    function test_fuzz_Adder(uint _a, uint _b) public {
        vm.assume(_a < 2**128);
        vm.assume(_b < 2**128);
        (uint sum, bool error) = basicMath.adder(_a, _b);
        if (error) {
            assertEq(sum, 0);
        } else {
            assertEq(sum, _a + _b);
        }
        
    }

    function test_fuzz_Subtractor(uint _a, uint _b) public {
        (uint difference, bool error) = basicMath.subtractor(_a, _b);
        if (error) {
            assertEq(difference, 0);
        } else {
            assertEq(difference, _a - _b);
        }
    }

    function test_AdderOverflow() public {
        (uint sum, bool error) = basicMath.adder(type(uint).max, 1);
        assertEq(sum, 0);
        assertTrue(error);
    }

    function test_SubtractorUnderflow() public {
        (uint difference, bool error) = basicMath.subtractor(0, 10);
        assertEq(difference, 0);
        assertTrue(error);
    }
}
