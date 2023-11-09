// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ArraysExercise} from "../src/ArraysExercise.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        ArraysExercise arraysExercise = new ArraysExercise();
        console2.logAddress(address(arraysExercise));
        vm.stopBroadcast();
    }
}

// Path: script/Deploy.s.sol
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast
