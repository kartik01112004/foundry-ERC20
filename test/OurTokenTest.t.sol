//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    uint256 public constant STARTING_BALANCE = 100 ether;

    address ram = makeAddr("ram");
    address shyam = makeAddr("shyam");

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(ram, STARTING_BALANCE);
    }

    function testRamBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(ram));
    }

    function testAllowencesWork() public {
        uint256 initialAllowence = 1000;

        // Ram Apporves Shyam to spend token on his behalf
        vm.prank(ram);
        ourToken.approve(shyam, initialAllowence);

        uint256 transferAmount = 500;

        vm.prank(shyam);
        ourToken.transferFrom(ram, shyam, transferAmount);

        assertEq(ourToken.balanceOf(shyam), transferAmount);
        assertEq(ourToken.balanceOf(ram), STARTING_BALANCE - transferAmount);
    }
}
