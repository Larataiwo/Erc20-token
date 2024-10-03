// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract Deploy is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;

    function run() external returns (Token) {
        vm.startBroadcast();
        Token token = new Token(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return token;
    }
}
