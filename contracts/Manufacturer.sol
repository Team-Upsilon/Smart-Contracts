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
    }

    struct Batch {
        uint256 batchId;
        uint256[] medicineIds;
        uint256[] medicineQuantities;
        address manufacturerId;
        uint256 manufacturingDate;
        Stages stage; 
        uint256 score;
    }

    enum Stages {
        preProduction,
        Stage1,
        Stage2,
        Packaging
    }

    uint256 public batchCount;
    mapping(uint256 => Batch) public batches;

    uint256 public medicineCount;
    mapping(uint256 => Medicine) public medicines;

    event BatchCreated(
        uint256 batchId,
        uint256[] medicineIds,
        uint256[] medicineQuantities,
        address indexed manufacturerId,
        uint256 manufacturingDate,
        Stages stage
    );

    event MedicineCreated(uint256 medicineId, string name, string description);
    event BatchStageUpdated(uint256 batchId, Stages newStage);

    function createBatch(
        uint256[] memory _medicineIds,
        uint256[] memory _medicineQuantities,
        uint256 estimatedCost,
        uint256 productionRatePerDay
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

        uint256 calculatedScore = batchSchedulerContract.calculateScore(productionRatePerDay,estimatedCost,actualQuantities);

        batches[currentBatchId] = Batch(
            currentBatchId,
            actualMedicineIds,
            actualQuantities,
            msg.sender,
            block.timestamp,
            Stages.preProduction,
            calculatedScore
        );

        emit BatchCreated(
            currentBatchId,
            actualMedicineIds,
            actualQuantities,
            msg.sender,
            block.timestamp,
            Stages.preProduction
        );
    }

    function createMedicine(
        string memory _name,
        string memory _description
    ) external {
        medicineCount++;
        medicines[medicineCount] = Medicine(
            medicineCount,
            _name,
            _description,
            0
        );

        emit MedicineCreated(medicineCount, _name, _description);
    }

    function updateBatchStage(uint256 _batchId, uint256 _newStage) external {
        Batch storage batch = batches[_batchId];
        require(batch.batchId != 0, "Batch not found");
        if(_newStage == 1) {

            require(batch.stage == Stages.preProduction, "Invalid stage transition");
            batch.stage = Stages.Stage1;

            emit BatchStageUpdated(_batchId, Stages.Stage1);
        }
        else if (_newStage == 2) {

            require(batch.stage == Stages.Stage1, "Invalid stage transition");
            batch.stage = Stages.Stage2;

            emit BatchStageUpdated(_batchId, Stages.Stage2);
        } else if (_newStage == 3) {

            require(batch.stage == Stages.Stage2, "Invalid stage transition");
            batch.stage = Stages.Packaging;

            emit BatchStageUpdated(_batchId, Stages.Packaging);
        }
    }

}
