// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import { AddressBookFactory } from "../src/AddressBookFactory.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
            AddressBookFactory addressBookFactory = new AddressBookFactory();
            console2.logAddress(address(addressBookFactory));
        vm.stopBroadcast();
    }
}

// Path: script/Deploy.s.sol
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast