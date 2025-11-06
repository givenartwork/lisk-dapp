// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LiskGarden {
    enum PlantStage { Seed, Sprout, Flower }

    struct Plant {
        PlantStage stage;
        uint256 lastWatered;
    }

    mapping(address => Plant) public garden;

    function plantSeed() public {
        require(garden[msg.sender].stage == PlantStage.Seed, "LiskGarden: You already have a plant");
        garden[msg.sender] = Plant({
            stage: PlantStage.Sprout,
            lastWatered: block.timestamp
        });
    }

    function waterPlant() public {
        require(garden[msg.sender].stage != PlantStage.Seed, "LiskGarden: You have not planted a seed yet");
        require(block.timestamp - garden[msg.sender].lastWatered > 1 days, "LiskGarden: You can only water your plant once a day");

        if (garden[msg.sender].stage == PlantStage.Sprout) {
            garden[msg.sender].stage = PlantStage.Flower;
        }

        garden[msg.sender].lastWatered = block.timestamp;
    }

    function harvestPlant() public {
        require(garden[msg.sender].stage == PlantStage.Flower, "LiskGarden: Your plant is not ready to be harvested");
        // In a real game, you would transfer some tokens to the user here
        delete garden[msg.sender];
    }
}
