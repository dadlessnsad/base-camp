// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    error ContactNotFound(uint id);

    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    Contact[] public contacts;

    constructor(address bookDeployer) Ownable(msg.sender) {}

    // Adds a new contact. Only the owner can add a contact.
    function addContact(string memory _firstName, string memory _lastName, uint[] memory _phoneNumbers) public onlyOwner {
        contacts.push(Contact(contacts.length, _firstName, _lastName, _phoneNumbers));
    }

    // Deletes a contact by id. Only the owner can delete a contact.
    function deleteContact(uint _id) public onlyOwner {
        if (_id >= contacts.length) {
            revert ContactNotFound(_id);
        }
        if (_id < contacts.length - 1) {
            contacts[_id] = contacts[contacts.length - 1];
        }
        contacts.pop();
    }

    // Retrieves a contact by id.
    function getContact(uint _id) public view returns (Contact memory) {
        if (_id >= contacts.length) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }

    function getAllContacts() public view returns (Contact[] memory) {
        return contacts;
    }

    function getAmountOfContacts() public view returns (uint) {
        return contacts.length;
    }
}
