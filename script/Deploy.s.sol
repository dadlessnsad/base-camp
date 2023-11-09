// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import { ControlStructures } from "../src/ControlStructures.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
            ControlStructures controlStructures = new ControlStructures();
            console2.logAddress(address(controlStructures));
        vm.stopBroadcast();
    }
    
}

// Path: script/Deploy.s.sol
// Deploy script for ControlStructures.sol
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast