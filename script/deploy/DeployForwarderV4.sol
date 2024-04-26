// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { DeployScriptBase } from "./utils/DeployScriptBase.sol";
import { stdJson } from "forge-std/Script.sol";
import { ForwarderV4 } from "bando/ForwarderV4.sol";

contract DeployForwarderV4 is DeployScriptBase {
    using stdJson for string;

    constructor() DeployScriptBase("ForwarderV4") {}

    function run()
        public
        returns (ForwarderV4 deployed)
    {
        deployed = ForwarderV4(deploy(type(ForwarderV4).creationCode));
    }
}
