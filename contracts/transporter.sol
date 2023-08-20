// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Inventory.sol";
import "./Supplier.sol";
import "./Inspector.sol";

contract Transporter {
    Inventory private inventoryContract;
    Supplier private supplierContract;
    Inspector private inspectorContract;

    constructor(address _inventoryAddress, address _supplierAddress, address _inspectorAddress) {
        inventoryContract = Inventory(_inventoryAddress);
        supplierContract = Supplier(_supplierAddress);
        inspectorContract = Inspector(_inspectorAddress);
    }

    struct Delivery {
        uint256 packageId;
        address supplierId;
        address transporterId;
        address inspectorId;
        uint256 deliveryTimestamp;
        bool delivered;
    }

    uint256 public deliveryCount;
    mapping(uint256 => Delivery) public deliveries;

    event DeliveryRecorded(
        uint256 packageId,
        address supplierId,
        address transporterId,
        address inspectorId,
        uint256 deliveryTimestamp
    );

    function recordDelivery(uint256 _packageId, address _inspectorId) external {
        require(supplierContract.rawMaterialPackages(_packageId).transporterId == address(this), "Transporter not authorized for this package");
        

        // checking if package is poor quality or not , need to write test doubtful
        require(inspectorContract.reports(_inspectorId).length > 0, "Inspector has not submitted a report");
        uint256 latestReportIndex = inspectorContract.reports(_inspectorId).length - 1;
        require(inspectorContract.reports(_inspectorId)[latestReportIndex].isinspected, "Package is droped due to poor quality");
        
        deliveryCount++;
        deliveries[deliveryCount] = Delivery(
            _packageId,
            supplierContract.rawMaterialPackages(_packageId).supplierId,
            msg.sender,
            _inspectorId,
            block.timestamp,
            true
        );

        emit DeliveryRecorded(
            _packageId,
            supplierContract.rawMaterialPackages(_packageId).supplierId,
            msg.sender,
            _inspectorId,
            block.timestamp
        );

    
    }

}
