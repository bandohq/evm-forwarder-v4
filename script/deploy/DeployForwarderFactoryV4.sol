// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { DeployScriptBase } from "./utils/DeployScriptBase.sol";
import { ForwarderFactoryV4 } from "bando/ForwarderFactoryV4.sol";
import { stdJson } from "forge-std/Script.sol";

contract DeployForwarderFactory is DeployScriptBase {
    using stdJson for string;

    constructor() DeployScriptBase("ForwarderFactoryV4") {}

    function run()
        public
        returns (ForwarderFactoryV4 deployed, bytes memory constructorArgs)
    {
        constructorArgs = getConstructorArgs();

        deployed = ForwarderFactoryV4(deploy(type(ForwarderFactoryV4).creationCode));
    }

    function getConstructorArgs() internal override returns (bytes memory) {
        // get path for specific network
        string memory networkConfigPath = string.concat(
            root,
            "/deployment_results/",
            network,
            ".json"
        );

        // read file into json variable
        string memory configJson = vm.readFile(networkConfigPath);

        // extract implementation address
        address implementationAddress = configJson.readAddress(
            ".forwarderAddress"
        );

        return abi.encode(implementationAddress);
    }
}
