// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract Staking {
    MyToken public token;

    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public lastStakeTime;

    uint256 public rewardRate = 10; // 10 tokens per second per staked token (simplified)

    constructor(address _tokenAddress) {
        token = MyToken(_tokenAddress);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Staking: Amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);

        if (stakedAmount[msg.sender] > 0) {
            calculateReward(msg.sender);
        }

        stakedAmount[msg.sender] += amount;
        lastStakeTime[msg.sender] = block.timestamp;
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Staking: Amount must be greater than 0");
        require(stakedAmount[msg.sender] >= amount, "Staking: Insufficient staked amount");

        calculateReward(msg.sender);

        stakedAmount[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
        lastStakeTime[msg.sender] = block.timestamp;
    }

    function calculateReward(address _staker) internal {
        if (stakedAmount[_staker] > 0) {
            uint256 timeElapsed = block.timestamp - lastStakeTime[_staker];
            rewards[_staker] += (stakedAmount[_staker] * rewardRate * timeElapsed) / 10**18; // Adjust for decimals
        }
    }

    function claimRewards() public {
        calculateReward(msg.sender);
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "Staking: No rewards to claim");
        rewards[msg.sender] = 0;
        token.transfer(msg.sender, reward);
    }

    function getStakedAmount(address _staker) public view returns (uint256) {
        return stakedAmount[_staker];
    }

    function getPendingRewards(address _staker) public view returns (uint256) {
        uint256 currentReward = rewards[_staker];
        if (stakedAmount[_staker] > 0) {
            uint256 timeElapsed = block.timestamp - lastStakeTime[_staker];
            currentReward += (stakedAmount[_staker] * rewardRate * timeElapsed) / 10**18; // Adjust for decimals
        }
        return currentReward;
    }
}
