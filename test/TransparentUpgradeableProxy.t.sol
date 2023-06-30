pragma solidity =0.8.19;

import "forge-std/Test.sol"; 
import "../TransparentUpgradeableProxy.sol";

//! ⛔️ DO NOT EDIT - GENERATED FILE ⛔️

contract TransparentUpgradeableProxyTest is Test {
    TransparentUpgradeableProxy proxy;
    address implementation;
    address admin;

    function setUp() public {
        admin = address(0x1337);
        implementation = address(0x1234);
        proxy = new TransparentUpgradeableProxy(implementation, admin);
    }

    function testCannotCallFallback() public {
        vm.expectRevert(abi.encodeWithSignature("TransparentUpgradeableProxy: admin cannot fallback to target implementation"));
        proxy.fallback();
    }

    function testCannotCallReceive() public {
        vm.expectRevert(abi.encodeWithSignature("TransparentUpgradeableProxy: admin cannot fallback to target implementation"));
        proxy.receive();
    }

    function testUpgradeTo() public {
        address newImplementation = address(0x1235);
        proxy.upgradeTo(newImplementation);
        assertEq(proxy.getProxyImplementation(), newImplementation);
    }

    function testUpgradeToAndCall() public {
        address newImplementation = address(0x1235);
        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 123);
        proxy.upgradeToAndCall{value: 123 ether}(newImplementation, data);
        assertEq(proxy.getProxyImplementation(), newImplementation);
        // Check `newImplementation` was initialized properly
        (bool success, ) = newImplementation.staticcall(abi.encodeWithSignature("getState()"));
        assertTrue(success);
    }

    function testOnlyAdminCanUpgrade() public {
        address notAdmin = address(0x1338);
        vm.expectRevert(abi.encodeWithSignature("TransparentUpgradeableProxy: admin only"));
        proxy.upgradeTo(notAdmin);
        vm.expectRevert(abi.encodeWithSignature("TransparentUpgradeableProxy: admin only"));
        proxy.upgradeToAndCall{value: 123 ether}(notAdmin, "");
    }
}
