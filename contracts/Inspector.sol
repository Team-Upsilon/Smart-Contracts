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
    mapping(address => report[]) public reports;

    function checkquality(
        uint256 _packageid,
        string memory _description,
        uint256 a,
        uint256 b,
        uint256 c,
        uint256 qa,
        uint256 qb,
        uint256 qc
    ) public {
        uint256 grade = ((a * qa) + (b * qb) + (c * qc)) / (qa + qb + qc);
        emit packagegrade(_packageid, grade);

        reportCount++;
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
