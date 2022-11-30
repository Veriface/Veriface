// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Owner
 * @dev Set & change owner
 */
interface IVeriface {
    function requireAddressWhiteListed(address sender, bool refuseService)
        external;

    function checkAddress(
        address sender,
        address callerContract,
        uint256 level
    ) external;
}

contract TestSpecimen {
    IVeriface secure;

    constructor(address veriface) {
        secure = IVeriface(veriface);
    }

    //black list tests

    //strict
    //prohibit blacklisted users from getting this data
    //code 0
    function getOwnerBlacklistStrict() external returns (address) {
        secure.checkAddress(msg.sender, address(this), 0);
        return address(this);
    }

    //warn if blacklisted users get this data
    //code 1
    function getOwnerBlacklistWarn() external returns (address) {
        secure.checkAddress(msg.sender, address(this), 1);
        return address(this);
    }

    //allow blacklisted users to get this data
    //code 2
    function getOwnerBlacklisIgnore() external returns (address) {
        secure.checkAddress(msg.sender, address(this), 2);
        return address(this);
    }

    //only whitelisted users can get this data
    function getOwnerWhitelist() external returns (address) {
        secure.requireAddressWhiteListed(msg.sender, true);
        return address(this);
    }
}
