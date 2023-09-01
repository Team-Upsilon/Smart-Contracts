// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Inventory.sol";

contract Supplier {
    Inventory private inventoryContract;

    constructor(address _inventoryAddress) {
        inventoryContract = Inventory(_inventoryAddress);
    }

    enum Stages {
        Requested,
        Created,
        Delivered,
        Inspected
    }

    struct RawMaterialPackage {
        uint256 packageId;
        uint256[] rawMaterialsIds;
        uint256[] rawMaterialsQuantities;
        string description;
        address manufacturerId;
        address transporterId;
        address supplierId;
        address inspectorId;
        Stages stage;
    }

    uint256 public packageCount;
    mapping(uint256 => RawMaterialPackage) public rawMaterialPackages;

    function requestRawMaterialPackage(
        uint256[] memory _rawMaterialsIds,
        uint256[] memory _rawMaterialsQuantities,
        string memory _description,
        address _manufacturerId,
        address _transporterId,
        address _supplierId,
        address _inspectorId
    ) external {
        require(
            _rawMaterialsIds.length == _rawMaterialsQuantities.length,
            "Invalid input lengths"
        );

        // Check if the requested raw material quantities are available
        for (uint256 i = 0; i < _rawMaterialsIds.length; i++) {
            uint256 materialId = _rawMaterialsIds[i];
            uint256 desiredQuantity = _rawMaterialsQuantities[i];

            require(
                inventoryContract.checkAvailability(
                    materialId,
                    desiredQuantity
                ) == desiredQuantity,
                "Insufficient raw material quantity"
            );

            // Deduct the raw material quantity from the inventory
            inventoryContract.decreaseQuantity(materialId, desiredQuantity);
        }

        packageCount++;
        uint256 currentPackageId = packageCount;

        rawMaterialPackages[currentPackageId] = RawMaterialPackage(
            currentPackageId,
            _rawMaterialsIds,
            _rawMaterialsQuantities,
            _description,
            _manufacturerId,
            _transporterId,
            _supplierId,
            _inspectorId,
            Stages.Requested
        );
    }

    function updatePackageStage(
        // this will be used to create a new package
        uint256 _packageId,
        uint256 _newStage
    ) external {
        RawMaterialPackage storage package = rawMaterialPackages[_packageId];
        require(package.packageId != 0, "Package not found");

        // Check if the package is currently in the expected previous stage
        if (_newStage == 1) {
            require(
                package.stage == Stages.Requested,
                "Invalid stage transition"
            );
            package.stage = Stages.Created;
        } else if (_newStage == 2) {
            require(
                package.stage == Stages.Created,
                "Invalid stage transition"
            );
            package.stage = Stages.Delivered;
        } else if (_newStage == 3) {
            require(
                package.stage == Stages.Delivered,
                "Invalid stage transition"
            );
            package.stage = Stages.Inspected;
        }
    }

    function getRawMaterialPackage(
        uint256 _packageId
    ) public view returns (RawMaterialPackage memory) {
        return rawMaterialPackages[_packageId];
    }
}
