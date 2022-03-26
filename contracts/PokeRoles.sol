// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract PokeRoles is Initializable, AccessControlUpgradeable {
    function initialize(address sender) public initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, sender);
    }

    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "Sender is not authorized");
        _;
    }

    function isAdmin(address account) public view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    function addAdmin(address account) public onlyAdmin {
        grantRole(DEFAULT_ADMIN_ROLE, account);
    }

    function revokeAdmin(address account) public onlyAdmin {
        revokeRole(DEFAULT_ADMIN_ROLE, account);
    }
}
