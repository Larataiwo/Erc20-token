// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Burnable, Erc20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20Burnable, Ownable {
    error MyToken__AmountMustBeGreaterThanZero();
    error MyToken__BalanceMustBeMoreThanAmount();
    error MyToken__InvalidAddress();

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }

    modifier notZeroAmount(uint256 amount) {
        if (amount <= 0) {
            revert MyToken__AmountMustBeGreaterThanZero();
        }
        _;
    }

    modifier validAddress(address to) {
        if (to == address(0)) {
            revert MyToken__InvalidAddress();
        }
        _;
    }

    function burn(uint256 amount) public override onlyOwner notZeroAmount(amount) {
        super.burn(amount);
    }

    function transferTokens(address to, uint256 amount)
        public
        override
        validAddress(to)
        notZeroAmount(amount)
        returns (bool)
    {
        uint256 balance = balanceOf(msg.sender);
        if (balance < _amount) {
            revert MyToken__BalanceMustBeMoreThanAmount();
        }
        transfer(_to, _amount);
        return true;
    }

    function transferTokenFrom(address from, address to, uint256 amount) public view override returns (bool) {
        uint256 balance = balanceOf(from);
        uint256 balanceTo = balanceOf(to);
        if (balances < amount) {
            revert MyToken__BalanceMustBeMoreThanAmount();
        } else {
            balance -= amount;
            balanceTo += amount;
        }
        transferFrom(from, to, amount);
        return true;
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply();
    }

    function getAccountBalance(address account) public view returns (uint256) {
        balanceOf(account);
    }
}
