// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Supplier.sol";
import "./Manufacturer.sol";

contract Transporter {
    Supplier private supplierContract;
    Manufacturer private manufacturerContract;

    constructor(address _supplierAddress, address _manufacturerAddress) {
        supplierContract = Supplier(_supplierAddress);
        manufacturerContract = Manufacturer(_manufacturerAddress);
    }

    struct PackageDelivery {
        uint256 packageId;
        address supplierId;
        address transporterId;
        uint256 deliveryTimestamp;
    }

    mapping(uint256 => PackageDelivery) public packageDeliveries;

    struct BatchDelivery {
        uint256 batchId;
        address manufacturerId;
        address transporterId;
        uint256 deliveryTimestamp;
    }

    mapping(uint256 => BatchDelivery) public batchDeliveries;

    function recordPackageDelivery(uint256 _packageId) external   {
        Supplier.RawMaterialPackage memory package = supplierContract
            .getRawMaterialPackage(_packageId);
        require(package.packageId != 0, "Package not found");

        require(
            package.transporterId == msg.sender,
            "Transporter not authorized for this package"
        );

        packageDeliveries[_packageId] = PackageDelivery(
            _packageId,
            package.supplierId,
            msg.sender,
            block.timestamp
        );

        supplierContract.updatePackageStage(_packageId, 2);
    }

    function recordBatchDelivery(uint256 _batchId) external {
        Manufacturer.Batch memory batch = manufacturerContract.getBatches(
            _batchId
        );
        require(batch.batchId != 0, "Batch not found");

        require(
            batch.transporterId == msg.sender,
            "Transporter not authorized for this batch"
        );

        batchDeliveries[_batchId] = BatchDelivery(
            _batchId,
            batch.manufacturerId,
            msg.sender,
            block.timestamp
        );

        manufacturerContract.updateBatchStage(_batchId, 4);
    }
}
