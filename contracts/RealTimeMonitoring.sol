// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Manufacturer.sol";

contract RealTimeMonitoring {
    Manufacturer private manufacturerContract;

    constructor(address _manufacturerAddress) {
        manufacturerContract = Manufacturer(_manufacturerAddress);
    }

    struct batchReport {
        uint256 batchId;
        uint256 stage;
        uint256 batchReportResult;
    }

    
    //batchId to struct
    mapping(uint256 => batchReport[]) public batchReports;

    function recordBatchReport(
        uint256 _batchId,
        uint256 stage,
        uint256[] memory stagecondition
    ) public {
        uint256 batchId = manufacturerContract.getBatchId(_batchId);
        require(batchId != 0, "Batch was not found");
        require(stage >= 1 && stage <= 3, "Invalid stage");
        require(
            stagecondition.length > 0,
            "batchReport parameters cannot be empty"
        );
        uint256[] memory idealstagecondition = manufacturerContract
            .getIdealStageCondition(_batchId, stage);
        require(
            idealstagecondition.length == stagecondition.length,
            "Invalid input"
        );

        uint256 totalDeviation = 0;
        for (uint256 i = 0; i < stagecondition.length; i++) {
            uint256 deviation = absDiff(
                stagecondition[i],
                idealstagecondition[i]
            );
            totalDeviation += deviation;
        }

        uint256 averageDeviation = (totalDeviation * 100) /
            (idealstagecondition.length *
                getMaxIdealValue(idealstagecondition));

        // Calculate the grading based on the average deviation
        uint256 grading = 10 - (averageDeviation / 10);

        // Ensure the grading is within the range 1-10
        if (grading < 1) {
            grading = 0;
        } else if (grading > 10) {
            grading = 10;
        }

        // Store the batchReport result in the mapping
        batchReport memory newBatchReport  = batchReport(_batchId, stage, grading);
        batchReports[_batchId].push(newBatchReport );

        // Update batchReportStage in Manufacturer contract
        manufacturerContract.updateInspectionStage(
            _batchId,
            stage
        );
    }

    function absDiff(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a > b) {
            return a - b;
        } else {
            return b - a;
        }
    }

    function getMaxIdealValue(
        uint256[] memory idealParameters
    ) internal pure returns (uint256) {
        uint256 max = 0;
        for (uint256 i = 0; i < idealParameters.length; i++) {
            if (idealParameters[i] > max) {
                max = idealParameters[i];
            }
        }
        return max;
    }
}
