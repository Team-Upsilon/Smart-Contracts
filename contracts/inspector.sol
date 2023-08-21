pragma solidity ^0.8.0;

contract inspector {
    event qualitychecked(uint256 packageid, uint256 grade);
    event packagegrade(uint256 packageid, uint256 grade);

    struct report {
        uint256 reportid;
        string description;
        uint256 packageid;
        uint256 grade;
        uint256 timestamp;
        address inspectorId;
        bool isApproved;
    }

    uint256 public reportCount;
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
            reports[msg.sender].push(
                report(
                    reportCount,
                    _description,
                    _packageid,
                    grade,
                    block.timestamp,
                    msg.sender,
                    true
                )
            );
        } else {
            reports[msg.sender].push(
                report(
                    reportCount,
                    _description,
                    _packageid,
                    grade,
                    block.timestamp,
                    msg.sender,
                    false
                )
            );
        }
    }
}
