// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ArraysExercise} from "../src/ArraysExercise.sol";

contract CounterTest is Test {
    ArraysExercise public arraysExercise;

    function setUp() public {
        arraysExercise = new ArraysExercise();
    }

    function testGetNumbers() public {
        uint[] memory numbers = arraysExercise.getNumbers();
        assertEq(numbers.length, 10);
        assertEq(numbers[0], 1);
        assertEq(numbers[9], 10);
    }

    function testResetNumbers() public {
        arraysExercise.resetNumbers();
        uint[] memory numbers = arraysExercise.getNumbers();
        assertEq(numbers.length, 10);
        assertEq(numbers[0], 1);
        assertEq(numbers[9], 10);
    }

    function testAppendToNumbers() public {
        uint[] memory toAppend = new uint[](3);
        toAppend[0] = 11;
        toAppend[1] = 12;
        toAppend[2] = 13;
        arraysExercise.appendToNumbers(toAppend);
        uint[] memory numbers = arraysExercise.getNumbers();
        assertEq(numbers.length, 13);
        assertEq(numbers[0], 1);
        assertEq(numbers[9], 10);
        assertEq(numbers[10], 11);
        assertEq(numbers[11], 12);
        assertEq(numbers[12], 13);
    }



}
