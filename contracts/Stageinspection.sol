// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Manufacturer.sol";

contract Inspector {
    Manufacturer private manufacturerContract;

    constructor(address _manufacturerAddress) {
        manufacturerContract = Manufacturer(_manufacturerAddress);
    }

    struct Inspection {
        uint256 batchId;
        uint256 stage;
        uint256 inspectionResult;
    }

    uint256 public inspectionCount;
    mapping(uint256 => Inspection[]) public batchInspections;

    // event InspectionRecorded(uint256 batchId, uint256 stage, string inspectionResult);
    // event InspectionReportGenerated(uint256 batchId, string report);

    modifier onlyManufacturer() {
        require(
            msg.sender == address(manufacturerContract),
            "Only the manufacturer can call this function"
        );
        _;
    }

    function recordinspection(
        uint256 _batchId,
        uint256 stage,
        uint256[] memory stagecondition
    ) public onlyManufacturer {
        uint256 batchId = manufacturerContract.getBtachId(_batchId);
        require(batchId != 0, "Batch not found");
        require(stage >= 1 && stage <= 3, "Invalid stage");
        require(
            stagecondition.length > 0,
            "Inspection parameters cannot be empty"
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
            Inspection memory inspection = Inspection(
                _batchId,
                stage,
                0
            );
        } else if (grading > 10) {
            Inspection memory inspection = Inspection(
                _batchId,
                stage,
                10
            );
        } else {
            Inspection memory inspection = Inspection(
                _batchId,
                stage,
                grading
            );
        }
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

