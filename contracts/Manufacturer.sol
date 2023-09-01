// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BatchScheduler.sol";
 
contract Manufacturer {
    BatchScheduler private batchSchedulerContract;

    constructor(address _batchSchedulerAddress) {
        batchSchedulerContract = BatchScheduler(_batchSchedulerAddress);
    }

    struct Medicine {
        uint256 medicineId;
        string name;
        string description;
        uint256 totalQuantity;
        string ipfs_hash; 
    }

    struct Batch {
        uint256 batchId;
        uint256[] medicineIds;
        uint256[] medicineQuantities;
        address manufacturerId;
        address transporterId;
        address wholesalerId;
        uint256 manufacturingDate;
        Stages stage;
        uint256 score;
        uint256[] idealstage1conditions; // [tempreture, pressure, concentration, PH Value]
        uint256[] idealstage2conditions;
        uint256[] idealpackagingconditions;
        address inspectorId;
        InspectionStages InspectionStage;
    }

    enum Stages {
        preProduction,
        Stage1,
        Stage2,
        Packaging,
        Delivered
    }

    enum InspectionStages {
        STAGE_0,
        STAGE_1,
        STAGE_2,
        STAGE_3
    }

    uint256 public batchCount;
    mapping(uint256 => Batch) public batches;

    uint256 public medicineCount;
    mapping(uint256 => Medicine) public medicines;

    function createBatch(
        uint256[] memory _medicineIds,
        uint256[] memory _medicineQuantities,
        uint256 estimatedCost,
        uint256 productionRatePerDay,
        uint256[] memory _idealstage1conditions,
        uint256[] memory _idealstage2conditions,
        uint256[] memory _idealpackagingconditions,
        address _inspectorId,
        address _transporterId,
        address _wholesalerId
    ) external {
        require(
            _medicineIds.length == _medicineQuantities.length,
            "Invalid input lengths"
        );

        batchCount++;
        uint256 currentBatchId = batchCount;

        uint256 totalMedicines = _medicineIds.length;
        uint256[] memory actualMedicineIds = new uint256[](totalMedicines);
        uint256[] memory actualQuantities = new uint256[](totalMedicines);

        for (uint256 i = 0; i < totalMedicines; i++) {
            uint256 medicineId = _medicineIds[i];
            uint256 medicineQuantity = _medicineQuantities[i];

            // Check if the medicine ID exists in the medicines mapping
            require(
                medicines[medicineId].medicineId != 0,
                "Invalid medicine ID"
            );

            actualMedicineIds[i] = medicineId;
            actualQuantities[i] = medicineQuantity;

            medicines[medicineId].totalQuantity += medicineQuantity;
        }

        uint256 calculatedScore = batchSchedulerContract.calculateScore(
            productionRatePerDay,
            estimatedCost,
            actualQuantities
        );

        batches[currentBatchId] = Batch(
            currentBatchId,
            actualMedicineIds,
            actualQuantities,
            msg.sender,
            _transporterId,
            _wholesalerId,
            block.timestamp,
            Stages.preProduction,
            calculatedScore,
            _idealstage1conditions,
            _idealstage2conditions,
            _idealpackagingconditions,
            _inspectorId,
            InspectionStages.STAGE_0
        );
    }

    function createMedicine(
        string memory _name,
        string memory _description,
        string memory _ipfs_hash
    ) external {
        medicineCount++;
        medicines[medicineCount] = Medicine(
            medicineCount,
            _name,
            _description,
            0,
            _ipfs_hash
        );

    }

    function updateBatchStage(uint256 _batchId, uint256 _newStage) external {
        Batch storage batch = batches[_batchId];
        require(batch.batchId != 0, "Batch not found");
        if (_newStage == 1) {
            require(
                batch.stage == Stages.preProduction,
                "Invalid stage transition"
            );
            batch.stage = Stages.Stage1;

        } else if (_newStage == 2) {
            require(batch.stage == Stages.Stage1, "Invalid stage transition");
            batch.stage = Stages.Stage2;

        } else if (_newStage == 3) {
            require(batch.stage == Stages.Stage2, "Invalid stage transition");
            batch.stage = Stages.Packaging;

        }
        else if (_newStage == 4) {
            require(batch.stage == Stages.Packaging, "Invalid stage transition");
            batch.stage = Stages.Delivered;

        }
    }

    function getBatchId(uint256 _batchId) public view returns (uint256) {
        return batches[_batchId].batchId;
    }

     function getBatches(uint256 _batchId) public view returns (Batch memory) {
        return batches[_batchId];
    }

    function getIdealStageCondition(
        uint256 _batchId,
        uint256 _stage
    ) public view returns (uint256[] memory) {
        Batch storage batch = batches[_batchId];
        require(batch.batchId != 0, "Batch not found");
        if (_stage == 1) {
            return batch.idealstage1conditions;
        } else if (_stage == 2) {
            return batch.idealstage2conditions;
        } else if (_stage == 3) {
            return batch.idealpackagingconditions;
        }
        revert("Invalid stage");
    }

    function updateInspectionStage(
        uint256 _batchId,
        uint256 _newStage
    ) external {
        Batch storage batch = batches[_batchId];
        require(batch.batchId != 0, "Batch not found");

        require(_newStage >= 1 && _newStage <= 3, "Invalid stage");

        if (_newStage == 1) {
            require(batch.stage == Stages.Stage1, "Invalid stage");
            batch.InspectionStage = InspectionStages.STAGE_1;
        } else if (_newStage == 2) {
            require(batch.stage == Stages.Stage2, "Invalid stage");
            batch.InspectionStage = InspectionStages.STAGE_2;
        } else if (_newStage == 3) {
            require(batch.stage == Stages.Packaging, "Invalid stage");
            batch.InspectionStage = InspectionStages.STAGE_3;
        }
    }
}
