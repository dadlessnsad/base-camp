// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";

import {EmployeeStorage} from "../src/EmployeeStorage.sol";

contract CounterTest is Test {
    EmployeeStorage public employeeStorage;

    function setUp() public {
        employeeStorage = new EmployeeStorage(
            "Pat",
            1000,
            50000,
            112358132134
        );
    }

    function testConstructor() public {
        assertEq(employeeStorage.name(), "Pat");
        assertEq(employeeStorage.viewSalary(), 50000);
        assertEq(employeeStorage.viewShares(), 1000);
        assertEq(employeeStorage.idNumber(), 112358132134);
    }

    function testGrantShares() public {
        employeeStorage.grantShares(1000);
        assertEq(employeeStorage.viewShares(), 2000);
    }
    
    function testGrantShares5000(uint16 _newShares) public {
        vm.assume(_newShares <= 4000);
        employeeStorage.grantShares(_newShares);
        assertEq(employeeStorage.viewShares(), 1000 + _newShares);
    }

    function testFailGrantSharesTooManyShares() public {
        employeeStorage.grantShares(5001);
        assertEq(employeeStorage.viewShares(), 1000);
    }

    // revert with custom error TooManyShares(newShares) when shares + _newShares > 5000
    function testFailGrantSharesTooManyShares2() public {
        employeeStorage.grantShares(4001);
        assertEq(employeeStorage.viewShares(), 1000);
    }
}
