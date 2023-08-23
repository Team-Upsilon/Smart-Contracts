// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    function add(Role storage role, address account) internal {
        require(!has(role, account), "Role already exists");
        role.bearer[account] = true;
    }

    function remove(Role storage role, address account) internal {
        require(has(role, account), "Role does not exist");
        role.bearer[account] = false;
    }

    function has(Role storage role, address account) internal view returns (bool) {
        return role.bearer[account];
    }
}
