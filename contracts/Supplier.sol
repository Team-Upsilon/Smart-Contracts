// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Inventory.sol";

contract Supplier {
    Inventory private inventoryContract;

    constructor(address _inventoryAddress) {
        inventoryContract = Inventory(_inventoryAddress);
    }

    enum Stages {
        Created,
        Delivered,
        Inspected
    }

    struct RawMaterialPackage {
        uint256 packageId;
        string description;
        address manufacturerId;
        address transporterId;
        address supplierId;
        address inspectorId;
        Stages stage;
    }

    uint256 public packageCount;
    mapping(uint256 => RawMaterialPackage) public rawMaterialPackages;

    event RawMaterialPackageCreated(
        uint256 packageId,
        string description,
        address indexed manufacturerId,
        address indexed transporterId,
        address indexed supplierId,
        address indexed inspectorId
    );

    event RawMaterialPackageStageUpdated(uint256 packageId, uint256 newStage);

    function createRawMaterialPackage(
        string memory _description,
        address _manufacturerId,
        address _transporterId,
        address _inspectorId
    ) external {
        packageCount++;
        rawMaterialPackages[packageCount] = RawMaterialPackage(
            packageCount,
            _description,
            _manufacturerId,
            _transporterId,
            msg.sender,
            _inspectorId,
            Stages.Created
        );

        emit RawMaterialPackageCreated(
            packageCount,
            _description,
            _manufacturerId,
            _transporterId,
            msg.sender,
            _inspectorId
        );
    }

    function updatePackageStage(uint256 _packageId, uint256 _newStage) external {
        RawMaterialPackage storage package = rawMaterialPackages[_packageId];
        require(package.packageId != 0, "Package not found");

        // Check if the package is currently in the expected previous stage
        if (_newStage == 2) {
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

        emit RawMaterialPackageStageUpdated(_packageId, _newStage);
    }
}
