// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { AddressBook } from "./AddressBook.sol";

contract AddressBookFactory {


    function deploy() public returns (AddressBook addressBook) {
        bytes32 salt = bytes32(0);
        bytes memory bytecode = abi.encodePacked(type(AddressBook).creationCode, abi.encode(msg.sender));

        address addr2 = Create2.deploy(0, salt, bytecode);
        addressBook = AddressBook(addr2);
        addressBook.transferOwnership(msg.sender);
    }

}
