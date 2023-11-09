// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Salesperson, EngineeringManager} from "../src/InheritanceExercise.sol";

contract CounterTest is Test {
    Salesperson salesperson;
    EngineeringManager manager;

    function setUp() public {
        salesperson = new Salesperson(55555, 12345, 20);
        manager = new EngineeringManager(54321, 11111, 200000);
    }

    function testSalesperson() public {
        assertEq(salesperson.idNumber(), 55555);
        assertEq(salesperson.managerId(), 12345);
        assertEq(salesperson.hourlyRate(), 20);
        assertEq(salesperson.getAnnualCost(), 41600);
    }

    function testManager() public {
        assertEq(manager.idNumber(), 54321);
        assertEq(manager.managerId(), 11111);
        assertEq(manager.annualSalary(), 200000);
        assertEq(manager.getAnnualCost(), 200000);
    }
}
