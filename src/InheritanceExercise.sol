// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// Employee
abstract contract employee {
    uint256 public idNumber;
    uint256 public managerId;

    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public virtual view returns (uint256);
}

// Salaried
contract Salaried is employee {
    uint256 public annualSalary;

    constructor(uint256 _idNumber, uint256 _managerId, uint256 _annualSalary) employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public virtual override view returns (uint256) {
        return annualSalary;
    }
}

// Hourly
contract Hourly is employee {
    uint256 public hourlyRate;

    constructor(uint256 _idNumber, uint256 _managerId, uint256 _hourlyRate) employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public virtual override view returns (uint256) {
        return hourlyRate * 2080;
    }
}

// Manager
contract Manager  {
    uint256[] public employeeIds;

    function addReport(uint256 _idNumber) public virtual {
        employeeIds.push(_idNumber);
    }

    function resetReports() public virtual{
        delete employeeIds;
    }
}

// Salesperson
contract Salesperson is Hourly {


    constructor(uint256 _idNumber, uint256 _managerId, uint256 _hourlyRate) 
        Hourly(_idNumber, _managerId, _hourlyRate) 
    {}

    function getAnnualCost() public override view returns (uint256) {
        return super.getAnnualCost();
    }
}


// Engineering Manager
contract EngineeringManager is Salaried, Manager {
    constructor(uint256 _idNumber, uint256 _managerId, uint256 _annualSalary) 
        Salaried(_idNumber, _managerId, _annualSalary) 
    {}

    function getAnnualCost() public override view returns (uint256) {
        return super.getAnnualCost();
    }

    function addReport(uint256 _idNumber) public override {
        super.addReport(_idNumber);
    }

    function resetReports() public override {
        super.resetReports();
    }


}

// Inheritance Submission
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
