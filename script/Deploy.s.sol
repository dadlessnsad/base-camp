// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import { UnburnableToken } from "../src/UnburnableToken.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
            UnburnableToken unburnableToken = new UnburnableToken();
            console2.logAddress(address(unburnableToken));
        vm.stopBroadcast();
    }
}

// Path: script/Deploy.s.sol
// forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_GOERLI_RPC_URL --verify --broadcast
