// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { GarageManager } from "../src/GarageManager.sol";

contract GarageManagerTest is Test, GarageManager {    
    GarageManager public garageManager;

    function setUp() public {
        garageManager = new GarageManager(); 
    }

/*
things to test:
    - addCar
    - getMyCars
    - getUserCars
    - car struct is created correctly (make, model, color, numberOfDoors)
    - updateCar
    - fail updateCar wrong index
    - resetMyGarage
    - check a users garage with the garage mapping
*/  

    function testAddCar() public {
        garageManager.addCar("make", "model", "color", 4);
        Car[] memory cars = garageManager.getMyCars();
        assertEq(cars.length, 1);
        assertEq(cars[0].make, "make");
        assertEq(cars[0].model, "model");
        assertEq(cars[0].color, "color");
        assertEq(cars[0].numberOfDoors, 4);
    }

    function testGetMyCars() public {
        garageManager.addCar("Subaru", "Outback", "Green", 4);
        garageManager.addCar("Subaru", "Forester", "Blue", 4);
        garageManager.addCar("Subaru", "Impreza", "Red", 4);

        Car[] memory cars = garageManager.getMyCars();
        assertEq(cars.length, 3);
        assertEq(cars[0].make, "Subaru");
        assertEq(cars[0].model, "Outback");
        assertEq(cars[0].color, "Green");
        assertEq(cars[1].make, "Subaru");
        assertEq(cars[1].model, "Forester");
        assertEq(cars[1].color, "Blue");
        assertEq(cars[2].make, "Subaru");
        assertEq(cars[2].model, "Impreza");
        assertEq(cars[2].color, "Red");
    }


    function testGetUserCars() public {
        garageManager.addCar("Subaru", "Outback", "Green", 4);
        garageManager.addCar("Subaru", "Forester", "Blue", 4);
        garageManager.addCar("Subaru", "Impreza", "Red", 4);

        Car[] memory cars = garageManager.getUserCars(address(this));
        assertEq(cars.length, 3);
        assertEq(cars[0].make, "Subaru");
        assertEq(cars[0].model, "Outback");
        assertEq(cars[0].color, "Green");
        assertEq(cars[1].make, "Subaru");
        assertEq(cars[1].model, "Forester");
        assertEq(cars[1].color, "Blue");
        assertEq(cars[2].make, "Subaru");
        assertEq(cars[2].model, "Impreza");
        assertEq(cars[2].color, "Red");
    }
    
    function testUpdateCar() public {
        garageManager.addCar("Subaru", "Outback", "Green", 4);


        garageManager.updateCar(0, "Subaru", "Forester", "Black", 4);

        Car[] memory cars = garageManager.getMyCars();
        assertEq(cars.length, 1);
        assertEq(cars[0].make, "Subaru");
        assertEq(cars[0].model, "Forester");
        assertEq(cars[0].color, "Black");
        assertEq(cars[0].numberOfDoors, 4);
    }

    function testFailUpdateCar() public {
        garageManager.addCar("Subaru", "Outback", "Green", 4);

        garageManager.updateCar(1, "Subaru", "Forester", "Black", 4);
    }

    function testResetMyGarage() public {
        garageManager.addCar("Subaru", "Outback", "Green", 4);
        garageManager.addCar("Subaru", "Forester", "Blue", 4);
        garageManager.addCar("Subaru", "Impreza", "Red", 4);

        Car[] memory cars = garageManager.getMyCars();
        assertEq(cars.length, 3);

        garageManager.resetMyGarage();

        cars = garageManager.getMyCars();
        assertEq(cars.length, 0);
    }
}
