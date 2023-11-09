// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Test, console2 } from "forge-std/Test.sol";
import { AddressBook } from "../src/AddressBook.sol";
import { AddressBookFactory } from "../src/AddressBookFactory.sol";

contract AddressBookTest is Test {
    AddressBookFactory public factory;
    AddressBook public addressBook;
    address public owner;
    address public alice;
    address public bob;
    address public carol;
    address public dave;
    address public eve;
    uint256 public ownerKeys = 0xB0AB;
    uint256 public aliceKeys = 0xA0A;
    uint256 public bobsKeys = 0xB0B;
    uint256 public carolsKeys = 0xC0C;
    uint256 public daveKeys = 0xD0D;
    uint256 public evesKeys = 0xE0E;
    uint256[] public alicePhoneNumbers = new uint256[](1);
    uint256[] public bobPhoneNumbers = new uint256[](1);


    function setUp() public {
        owner = address(0xB0AB);
        alice = address(0xA0A);
        vm.deal(alice, 10 ether);
        bob = address(0xB0B);
        vm.deal(bob, 10 ether);
        carol = address(0xC0C);
        vm.deal(carol, 10 ether);
        dave = address(0xD0D);
        vm.deal(dave, 10 ether);
        eve = address(0xE0E);
        vm.deal(eve, 10 ether);
        factory = new AddressBookFactory();

        vm.startPrank(owner);
            addressBook = factory.deploy();
            assertEq(addressBook.owner(), address(owner));

            bytes memory bytecode = abi.encodePacked(type(AddressBook).creationCode, abi.encode(address(owner)));
            bytes32 salt = bytes32(0);
            address expectedAddress = address(uint160(uint(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(factory),
                salt,
                keccak256(bytecode)
            )))));
            assertEq(address(addressBook), expectedAddress);
        vm.stopPrank();
    }

    function testAddContact() public {
        vm.startPrank(owner);
            alicePhoneNumbers[0] = 5555555555;
            addressBook.addContact("Alice", "Smith", alicePhoneNumbers);

            bobPhoneNumbers[0] = 6666666666;
            addressBook.addContact("Bob", "Smith", bobPhoneNumbers);

            // get All contacts
            AddressBook.Contact[] memory contacts = addressBook.getAllContacts();
            assertEq(contacts.length, 2);
            assertEq(contacts[0].firstName, "Alice");
            assertEq(contacts[0].lastName, "Smith");
            assertEq(contacts[0].phoneNumbers.length, 1);
            assertEq(contacts[0].phoneNumbers[0], 5555555555);
            assertEq(contacts[1].firstName, "Bob");
            assertEq(contacts[1].lastName, "Smith");
            assertEq(contacts[1].phoneNumbers.length, 1);
            assertEq(contacts[1].phoneNumbers[0], 6666666666);
        vm.stopPrank();
    }

    function testDeleteContact() public {
        vm.startPrank(owner);
            alicePhoneNumbers[0] = 5555555555;
            addressBook.addContact("Alice", "Smith", alicePhoneNumbers);

            bobPhoneNumbers[0] = 6666666666;
            addressBook.addContact("Bob", "Smith", bobPhoneNumbers);

            // get All contacts
            AddressBook.Contact[] memory contacts = addressBook.getAllContacts();
            assertEq(contacts.length, 2);
            assertEq(contacts[0].firstName, "Alice");
            assertEq(contacts[0].lastName, "Smith");
            assertEq(contacts[0].phoneNumbers.length, 1);
            assertEq(contacts[0].phoneNumbers[0], 5555555555);
            assertEq(contacts[1].firstName, "Bob");
            assertEq(contacts[1].lastName, "Smith");
            assertEq(contacts[1].phoneNumbers.length, 1);
            assertEq(contacts[1].phoneNumbers[0], 6666666666);

            // delete contact
            addressBook.deleteContact(0);

            // get All contacts
            contacts = addressBook.getAllContacts();
            assertEq(contacts.length, 1);
            assertEq(contacts[0].firstName, "Bob");
            assertEq(contacts[0].lastName, "Smith");
            assertEq(contacts[0].phoneNumbers.length, 1);
            assertEq(contacts[0].phoneNumbers[0], 6666666666);
        vm.stopPrank();
    }

    function testGetContactById() public {
        vm.startPrank(owner);
            alicePhoneNumbers[0] = 5555555555;
            addressBook.addContact("Alice", "Smith", alicePhoneNumbers);

            bobPhoneNumbers[0] = 6666666666;
            addressBook.addContact("Bob", "Smith", bobPhoneNumbers);

            // get contact by id
            AddressBook.Contact memory contact = addressBook.getContact(0);
            assertEq(contact.firstName, "Alice");
            assertEq(contact.lastName, "Smith");
            assertEq(contact.phoneNumbers.length, 1);
            assertEq(contact.phoneNumbers[0], 5555555555);
        vm.stopPrank();
    }

}
