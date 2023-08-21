pragma solidity ^0.8.0;

import "./Supplier.sol";

contract Inspector {
    Supplier private supplierContract;

    constructor(address _supplierAddress) {
        supplierContract = Supplier(_supplierAddress);
    }

    event packagegrade(uint256 packageid, uint256 grade);

    struct report {
        uint256 packageid;
        string description;
        uint256 grade;
        uint256 timestamp;
        address inspectorId;
        bool isApproved;
    }
    
    // packageid to report
    mapping(uint256 => report[]) public reports;

    function checkquality(
        uint256 _packageid,
        string memory _description,
        uint256[] memory _quantity,
        uint256[] memory concentration
    ) public {
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

        //generate report
        if (grade >= 7) {
            reports[_packageid].push(
                report(
                    _packageid,
                    _description,
                    grade,
                    block.timestamp,
                    msg.sender,
                    true
                )
            );
        } else {
            reports[_packageid].push(
                report(
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
