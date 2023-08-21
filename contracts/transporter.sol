// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Supplier.sol";
import "./Inspector.sol";

contract Transporter {
    Supplier private supplierContract;
    Inspector private inspectorContract;

    constructor(
        address _inventoryAddress,
        address _supplierAddress,
        address _inspectorAddress
    ) {
        supplierContract = Supplier(_supplierAddress);
        inspectorContract = Inspector(_inspectorAddress);
    }

    struct Delivery {
        uint256 deliveryId;
        uint256 packageId;
        address supplierId;
        address transporterId;
        address inspectorId;
        uint256 deliveryTimestamp;
        bool isInspected;
    }

    uint256 public deliveryCount;
    mapping(uint256 => Delivery) public deliveries;

    event DeliveryRecorded(
        uint256 deliveryId,
        uint256 packageId,
        address supplierId,
        address transporterId,
        address inspectorId,
        uint256 deliveryTimestamp
    );

    function recordDelivery(uint256 _packageId, address _inspectorId) external {
        require(
            supplierContract.rawMaterialPackages(_packageId).transporterId ==
                address(this),
            "Transporter not authorized for this package"
        );

        deliveryCount++;
        deliveries[deliveryCount] = Delivery(
            deliveryCount,
            _packageId,
            supplierContract.rawMaterialPackages(_packageId).supplierId,
            msg.sender,
            _inspectorId,
            block.timestamp,
            false
        );

        emit DeliveryRecorded(
            deliveryCount,
            _packageId,
            supplierContract.rawMaterialPackages(_packageId).supplierId,
            msg.sender,
            _inspectorId,
            block.timestamp,
            false
        );
    }
}
