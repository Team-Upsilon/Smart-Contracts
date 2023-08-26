// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Admin {
    address public admin;

    // mappings to store the addresses of the different roles
    mapping(address => bool) public manufacturers;
    mapping(address => bool) public inspectors;
    mapping(address => bool) public suppliers;
    mapping(address => bool) public transporters;
    mapping(address => bool) public wholesalers;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "Only admin can call the function ");
        _;
    }

    function addWholesaler(address _account) external onlyAdmin {
        require(!wholesalers[_account], "wholesaler already exists");
        wholesalers[_account] = true;
    }

    function removeWholesaler(address _account) external onlyAdmin {
        require(wholesalers[_account], "wholesaler does not exist");
        wholesalers[_account] = false;
    }

    function addManufacturer(address _account) external onlyAdmin {
        require(!manufacturers[_account], "Manufacturer already exists");
        manufacturers[_account] = true;
    }

    function removeManufacturer(address _account) external onlyAdmin {
        require(manufacturers[_account], "Manufacturer does not exist");
        manufacturers[_account] = false;
    }

    function addInspector(address _account) external onlyAdmin {
        require(!inspectors[_account], "Inspector already exists");
        inspectors[_account] = true;
    }

    function removeInspector(address _account) external onlyAdmin {
        require(inspectors[_account], "Inspector does not exist");
        inspectors[_account] = false;
    }

    function addSupplier(address _account) external onlyAdmin {
        require(!suppliers[_account], "Supplier already exists");
        suppliers[_account] = true;
    }

    function removeSupplier(address _account) external onlyAdmin {
        require(suppliers[_account], "Supplier does not exist");
        suppliers[_account] = false;
    }

    function addTransporter(address _account) external onlyAdmin {
        require(!transporters[_account], "Transporter already exists");
        transporters[_account] = true;
    }

    function removeTransporter(address _account) external onlyAdmin {
        require(transporters[_account], "Transporter does not exist");
        transporters[_account] = false;
    }

    function updateAdmin(address _newAdmin) external onlyAdmin {
        admin = _newAdmin;
    }
}
