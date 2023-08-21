// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Supplier.sol";

contract Transporter {
    Supplier private supplierContract;

    constructor(
        address _supplierAddress
    ) {
        supplierContract = Supplier(_supplierAddress);
    }

    struct Delivery {
        uint256 packageId;
        address supplierId;
        address transporterId;
        uint256 deliveryTimestamp;
    }
    
    // packageId to Delivery struct
    mapping(uint256 => Delivery) public deliveries;

    event DeliveryRecorded(
        uint256 packageId,
        address supplierId,
        address transporterId,
        uint256 deliveryTimestamp
    );

    function recordDelivery(uint256 _packageId) external {
        require(
            supplierContract.rawMaterialPackages(_packageId).transporterId ==
                address(this),
            "Transporter not authorized for this package"
        );

        deliveries[_packageId] = Delivery(
            _packageId,
            supplierContract.rawMaterialPackages(_packageId).supplierId,
            msg.sender,
            block.timestamp
        );

        // Update the package stage to "Delivered" in Supplier contract
        supplierContract.updatePackageStage(_packageId, 2);

        emit DeliveryRecorded(
            _packageId,
            supplierContract.rawMaterialPackages(_packageId).supplierId,
            msg.sender,
            block.timestamp
        );
    }
}
