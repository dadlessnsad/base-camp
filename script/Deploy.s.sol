// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {EmployeeStorage} from "../src/EmployeeStorage.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
            EmployeeStorage employeeStorage = new EmployeeStorage(
                "Pat",
                1000,
                50000,
                112358132134
            );
        console2.logAddress(address(employeeStorage));
        vm.stopBroadcast();
    }
}

// Path: script/Deploy.s.sol 
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast