// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Inventory.sol";

contract Supplier {
    Inventory private inventoryContract;

    constructor(address _inventoryAddress) {
        inventoryContract = Inventory(_inventoryAddress);
    }

    struct RawMaterialPackage {
        uint256 packageId;
        string description;
        address manufacturerId;
        address transporterId;
        address supplierId;
    }

    uint256 public packageCount;
    mapping(uint256 => RawMaterialPackage) public rawMaterialPackages;

    event RawMaterialPackageCreated(
        uint256 packageId,
        string description,
        address indexed manufacturerId,
        address indexed transporterId,
        address indexed supplierId
    );

    function createRawMaterialPackage(
        string memory _description,
        address _manufacturerId,
        address _transporterId
    ) external {
        packageCount++;
        rawMaterialPackages[packageCount] = RawMaterialPackage(
            packageCount,
            _description,
            _manufacturerId,
            _transporterId,
            msg.sender
        );

        emit RawMaterialPackageCreated(
            packageCount,
            _description,
            _manufacturerId,
            _transporterId,
            msg.sender
        );
    }

    // function createRawMaterialPackage(
    //     string memory _name,
    //     uint256 _quantity
    // ) external {
    //     inventoryContract.addRawMaterial(_name, _quantity);
    // }

    // function updateRawMaterialPackage(
    //     uint256 _materialId,
    //     string memory _newName,
    //     uint256 _newQuantity
    // ) external {
    //     inventoryContract.updateRawMaterial(
    //         _materialId,
    //         _newName,
    //         _newQuantity
    //     );
    // }

    // function getInventoryStatus(
    //     uint256 _materialId
    // ) external view returns (uint256) {
    //     return inventoryContract.checkAvailability(_materialId, 0);
    // }
}
