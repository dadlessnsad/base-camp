// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "../lib/forge-std/src/Test.sol";
import {Vm} from  "../lib/forge-std/src/Vm.sol";
import { ControlStructures } from "../src/ControlStructures.sol";

contract ControlStructuresTest is Test {
    ControlStructures public controlStructures;

    function setUp() public {
        controlStructures = new ControlStructures();
    }

    // "Fizz" if the _number is divisible by 3
    function testFizzBuzzFizz(uint _number) public {
        vm.assume(_number % 3 == 0 && _number % 5 != 0);
        string memory result = controlStructures.fizzBuzz(_number);
        assertEq(result, "Fizz");
    }

    // "Buzz" if the _number is divisible by 5
    function testFizzBuzzBuzz(uint _number) public {
        vm.assume(_number % 5 == 0 && _number % 3 != 0);
        string memory result = controlStructures.fizzBuzz(_number);
        assertEq(result, "Buzz");
    }
    
    // "FizzBuzz" if the _number is divisible by 3 and 5
    function testFizzBuzzFizzBuzz(uint _number) public {
        vm.assume(_number % 3 == 0 && _number % 5 == 0);
        string memory result = controlStructures.fizzBuzz(_number);
        assertEq(result, "FizzBuzz");
    }

    // "Splat" if none of the above conditions are true
    function testFizzBuzzSplat(uint _number) public {
        vm.assume(_number % 3 != 0 && _number % 5 != 0);
        string memory result = controlStructures.fizzBuzz(_number);
        assertEq(result, "Splat");
    }

    // If _time is greater than or equal to 2400, trigger a panic
    function testfailDoNotDisturbPanic(uint _time) public {
        vm.assume(_time >= 2400);
        vm.expectRevert();
        controlStructures.doNotDisturb(_time);
    }

    // If _time is greater than 2200, but not more than 2400, or less than 800, revert with a custom error of AfterHours, and include the time provided
    function testfailDoNotDisturbAfterHours(uint _time) public {
        vm.assume(_time > 2200 && _time < 2400 || _time < 800);
        vm.expectRevert();
        controlStructures.doNotDisturb(_time);
    }
    // If _time is between 1200 and 1259, revert with a string message "At lunch!"
    
    // If _time is between 800 and 1199, return "Morning!"
    
    // If _time is between 1300 and 1799, return "Afternoon!"
    
    // If _time is between 1800 and 2200, return "Evening!"
}
