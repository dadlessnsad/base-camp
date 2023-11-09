// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ErrorTriageExercise} from "../src/ErrorTriageExercise.sol";

contract ErrorTriageExerciseTest is Test {
    ErrorTriageExercise public errorTriageExercise;

    function setUp() public {
        errorTriageExercise = new ErrorTriageExercise();
    }

    function testDiffWithNeighbor() public {
        uint[] memory results = errorTriageExercise.diffWithNeighbor(1, 2, 3, 4);
        assertEq(results[0], 1);
        assertEq(results[1], 1);
        assertEq(results[2], 1);
    }

    function testApplyModifier() public {
        assertEq(errorTriageExercise.applyModifier(1001, 100), 1101);
        assertEq(errorTriageExercise.applyModifier(1001, -100), 901);
    }

    function testPopWithReturn() public {
        // add to array with addToArr
        errorTriageExercise.addToArr(1);
        errorTriageExercise.addToArr(4);
        errorTriageExercise.addToArr(7);
    
        // pop from array with popWithReturn
        assertEq(errorTriageExercise.popWithReturn(), 7);
    }




}
