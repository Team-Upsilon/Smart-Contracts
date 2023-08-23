// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Roles.sol";

contract Admin {
    using Roles for Roles.Role;

    address public admin;
    Roles.Role public manufacturers;
    Roles.Role public inspectors;
    Roles.Role public suppliers; 
    Roles.Role public transporters;
    Roles.Role public stageInspectors;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyManufacturer() {
        require(manufacturers.has(msg.sender), "Only manufacturers can call this function");
        _;
    }

    modifier onlyInspector() {
        require(inspectors.has(msg.sender), "Only inspectors can call this function");
        _;
    }

    modifier onlySupplier() {
        require(suppliers.has(msg.sender), "Only suppliers can call this function");
        _;
    }

    modifier onlyTransporter() {
        require(transporters.has(msg.sender), "Only transporters can call this function");
        _;
    }

    modifier onlyStageInspector() {
        require(stageInspectors.has(msg.sender), "Only stage inspectors can call this function");
        _;
    }

    function addManufacturer(address _account) external onlyAdmin {
        manufacturers.add(_account);
    }

    function removeManufacturer(address _account) external onlyAdmin {
        manufacturers.remove(_account);
    }

    function addInspector(address _account) external onlyAdmin {
        inspectors.add(_account);
    }

    function removeInspector(address _account) external onlyAdmin {
        inspectors.remove(_account);
    }

    function addSupplier(address _account) external onlyAdmin {
        suppliers.add(_account);
    }

    function removeSupplier(address _account) external onlyAdmin {
        suppliers.remove(_account);
    }

    function addTransporter(address _account) external onlyAdmin {
        transporters.add(_account);
    }

    function removeTransporter(address _account) external onlyAdmin {
        transporters.remove(_account);
    }

    function addStageInspector(address _account) external onlyAdmin {
        stageInspectors.add(_account);
    }

    function removeStageInspector(address _account) external onlyAdmin {
        stageInspectors.remove(_account);
    }

    function updateAdmin(address _newAdmin) external onlyAdmin {
        admin = _newAdmin;
    }
}
