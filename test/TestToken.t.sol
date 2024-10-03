// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";
import {Deploy} from "../script/DeployToken.s.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract TestToken is Test {
    Token public token;
    Deploy public deployer;
    uint256 bobInitialBalance = 100 ether;

    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;
    address public constant BOB = address(1);
    address public constant ALICE = address(2);

    function setUp() public {
        token = new Token(INITIAL_SUPPLY);
        token.transfer(msg.sender, INITIAL_SUPPLY);
        deployer = new Deploy();

        vm.prank(msg.sender);
        token.transfer(BOB, bobInitialBalance);
    }

    function testTotalSupply() public view {
        token.totalSupply();
        assertEq(token.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(token)).mint(address(this), 1);
    }

    function testBalance() public view {
        uint256 balance = token.totalSupply() - token.balanceOf(BOB);
        assertEq(token.balanceOf(msg.sender), balance);
    }

    function testTransfer() public {
        address MARK = address(3);
        vm.prank(msg.sender);
        token.transfer(MARK, 500 ether);
        uint256 balance = token.totalSupply() - (token.balanceOf(BOB) + token.balanceOf(MARK));
        assertEq(token.balanceOf(msg.sender), balance);
    }

    function testTransferFrom() public {
        vm.prank(BOB);
        token.approve(ALICE, 20 ether); //BOB approve ALICE to spend a maximum of 20 ethers on his behalf

        vm.prank(ALICE);
        token.transferFrom(BOB, ALICE, 10 ether);
        assertEq(token.balanceOf(BOB), bobInitialBalance - 10 ether);
        assertEq(token.balanceOf(ALICE), 10 ether);

        vm.prank(ALICE);
        token.transferFrom(BOB, ALICE, 10 ether);
        assertEq(token.balanceOf(BOB), bobInitialBalance - token.balanceOf(ALICE));
        assertEq(token.balanceOf(ALICE), 20 ether);
    }

    function testTokenName() public view {
        assertEq(token.name(), "MyToken");
        assertEq(token.symbol(), "MTK");
    }

    function testDeployment() public {
        token = deployer.run();
        assertTrue(address(token) != address(0));

        assertTrue(deployer.INITIAL_SUPPLY() == INITIAL_SUPPLY);
    }
}
