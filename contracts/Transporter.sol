// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Supplier.sol";
import "./Manufacturer.sol";
import "./Admin.sol";

contract Transporter {
    Supplier private supplierContract;
    Manufacturer private manufacturerContract;
    Admin private adminContract;

    constructor(address _supplierAddress, address _manufacturerAddress, address _adminAddress) {
        supplierContract = Supplier(_supplierAddress);
        manufacturerContract = Manufacturer(_manufacturerAddress);
        adminContract = Admin(_adminAddress);
    }

    modifier onlyAdminorOnlyTransporter() {
        require(
            adminContract.admin() == msg.sender ||
                adminContract.transporters(msg.sender),
            "Only admin or transporter can call this function");
        _;
    }

    modifier onlyTransporter(){
        require(
            adminContract.transporters(msg.sender),
            "Only Transporter can call this function"
        );
        _;
    }
    

    struct PackageDelivery {
        uint256 packageId;
        address supplierId;
        address transporterId;
        uint256 deliveryTimestamp;
    }

    mapping(uint256 => PackageDelivery) public packageDeliveries;

    event PackageDeliveryRecorded(
        uint256 packageId,
        address supplierId,
        address transporterId,
        uint256 deliveryTimestamp
    );

    struct BatchDelivery {
        uint256 batchId;
        address manufacturerId;
        address transporterId;
        uint256 deliveryTimestamp;
    }

    mapping(uint256 => BatchDelivery) public batchDeliveries;

    event BatchDeliveryRecorded(
        uint256 batchId,
        address manufacturerId,
        address transporterId,
        uint256 deliveryTimestamp
    );

    function recordPackageDelivery(uint256 _packageId) external onlyAdminorOnlyTransporter   {
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

        emit PackageDeliveryRecorded(
            _packageId,
            package.supplierId,
            msg.sender,
            block.timestamp
        );
    }

    function recordBatchDelivery(uint256 _batchId) external onlyAdminorOnlyTransporter {
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

        emit BatchDeliveryRecorded(
            _batchId,
            batch.manufacturerId,
            msg.sender,
            block.timestamp
        );
    }
}
