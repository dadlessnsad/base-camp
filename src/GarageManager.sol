// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GarageManager {
    error BadCarIndex(uint index);

    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    function addCar(
        string memory make,
        string memory model,
        string memory color,
        uint numberOfDoors
    ) public {
        Car memory car = Car(make, model, color, numberOfDoors);
        garage[msg.sender].push(car);
    }

    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    function updateCar(
        uint256 index,
        string memory make,
        string memory model,
        string memory color,
        uint numberOfDoors
    ) public {
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }
        Car memory car = Car(make, model, color, numberOfDoors);
        garage[msg.sender][index] = car;
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }

}   
