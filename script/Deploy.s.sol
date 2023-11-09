// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import { BasicMath } from "../src/BasicMath.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
            BasicMath basicMath = new BasicMath();
            console2.logAddress(address(basicMath));
        vm.stopBroadcast();
    }
    
}

// Path: script/Deploy.s.sol
// Deploy script for BasicMath.sol
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast