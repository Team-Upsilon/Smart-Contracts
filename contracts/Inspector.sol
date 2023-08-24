// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Supplier.sol";
import "./Admin.sol";

contract Inspector {
    Supplier private supplierContract;
    Admin private adminContract;

    constructor(address _supplierAddress, address _adminAddress) {
        supplierContract = Supplier(_supplierAddress);
        adminContract = Admin(_adminAddress);
    }

    event packagegrade(uint256 packageid, uint256 grade);

    modifier onlyAdminorOnlyInspector() {
        require(
            adminContract.admin() == msg.sender ||
                adminContract.inspectors(msg.sender),
            "Only admin or inspector can call this function"
        );
        _;
    }

 

    struct packageReport {
        uint256 packageid;
        string description;
        uint256 grade;
        uint256 timestamp;
        address inspectorId;
        bool isApproved;
    }
    
    // packageid to packageReport
    mapping(uint256 => packageReport[]) public packageReports;

 function checkquality(
        uint256 _packageid,
        string memory _description,
        uint256[] memory _quantity,
        uint256[] memory concentration
    ) public onlyAdminorOnlyInspector{
        require(_quantity.length == concentration.length, "Invalid input");
        uint256 grade = 0;
        uint256 totalquantity = 0;
        for (uint256 i = 0; i < _quantity.length; i++) {
            if (_quantity[i] > 0) {
                grade += _quantity[i] * concentration[i];
                totalquantity += _quantity[i];
            }
        }
        grade = grade / totalquantity;
        emit packagegrade(_packageid, grade);

        

        //generate packageReport
        if (grade >= 7) {
            packageReports[_packageid].push(
                packageReport(
                    _packageid,
                    _description,
                    grade,
                    block.timestamp,
                    msg.sender,
                    true
                )
            );
        } else {
            packageReports[_packageid].push(
                packageReport(
                    _packageid,
                    _description,
                    grade,
                    block.timestamp,
                    msg.sender,
                    false
                )
            );
        }

        // Update the package stage in Supplier contract
        supplierContract.updatePackageStage(_packageid, 3);
    }
}
