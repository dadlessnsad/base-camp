// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

error TooManyShares(uint256 shares);
contract EmployeeStorage {
    uint16 private shares;
    uint32 private salary;
    uint public idNumber;
    string public name;

    constructor(
        string memory _name,
        uint16 _shares,
        uint32 _salary,
        uint _idNumber
    ) {
        name = _name;
        shares = _shares;
        salary = _salary;
        idNumber = _idNumber;
    }

    function viewSalary() public view returns (uint256) {
        return salary;
    }

    function viewShares() public view returns (uint256) {
        return shares;
    }


    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        uint16 newShares = shares + _newShares;
        if (newShares > 5000) {
            revert TooManyShares(newShares);
        }
        shares = newShares;
    }

    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}
