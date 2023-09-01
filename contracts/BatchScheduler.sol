// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Manufacturer.sol";

contract BatchScheduler {

    function calculateScore(
        uint256 productionRatePerDay,
        uint256 estimatedCost,
        uint256[] memory medicineQuantities
    ) external pure returns (uint256) {
        uint256 totalOutputMedicines = 0;
        for (uint256 i = 0; i < medicineQuantities.length; i++) {
            totalOutputMedicines += medicineQuantities[i];
        }

        // Calculate the number of days required to produce the whole batch
        uint256 daysRequired = totalOutputMedicines / productionRatePerDay;

        // Apply the weighted average formula
        uint256 weightedDays = (daysRequired * 60) / 100;
        uint256 weightedCost = (estimatedCost * 40) / 100;

        // Calculate the score as a percentage of the total
        uint256 totalWeightedScore = weightedDays + weightedCost;
        uint256 maxTotalScore = 60 + 40; // 100%

        // Score to a percentage value
        uint256 scoreInPercentage = (totalWeightedScore * 100) / maxTotalScore;

        return scoreInPercentage;
    }
}
