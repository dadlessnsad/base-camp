// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Salesperson, EngineeringManager, InheritanceSubmission } from "../src/InheritanceExercise.sol";


contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
            Salesperson salesperson = new Salesperson(55555, 12345, 20);
            EngineeringManager manager = new EngineeringManager(54321, 11111, 200000);
            

            InheritanceSubmission submission = new InheritanceSubmission(address(salesperson), address(manager));

        vm.stopBroadcast();
    }
}

// Path: script/Deploy.s.sol
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast