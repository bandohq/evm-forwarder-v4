// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { DeployScriptBase } from "./utils/DeployScriptBase.sol";
import { stdJson } from "forge-std/Script.sol";
import { ForwarderV4 } from "bando/ForwarderV4.sol";

contract DeployScript is DeployScriptBase {
    using stdJson for string;

    constructor() DeployScriptBase("FeeCollector") {}

    function run()
        public
        returns (FeeCollector deployed, bytes memory constructorArgs)
    {
        constructorArgs = getConstructorArgs();

        deployed = FeeCollector(deploy(type(FeeCollector).creationCode));
    }

    function getConstructorArgs() internal override returns (bytes memory) {
        // get path of global config file
        string memory globalConfigPath = string.concat(
            root,
            "/config/global.json"
        );

        // read file into json variable
        string memory globalConfigJson = vm.readFile(globalConfigPath);

        // extract refundWallet address
        address withdrawWalletAddress = globalConfigJson.readAddress(
            ".withdrawWallet"
        );

        return abi.encode(withdrawWalletAddress);
    }
}