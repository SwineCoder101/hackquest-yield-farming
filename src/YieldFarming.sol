// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Treasury.sol";

contract YieldFarming is Ownable {
    IERC20 public lpToken;
    Treasury public treasury;
    uint256 public rewardRate = 1000; // Example reward rate

    struct Stake {
        uint256 amount;
        uint256 rewardDebt;
    }

    mapping(address => Stake) public stakes;

    constructor(IERC20 _lpToken, Treasury _treasury) Ownable(msg.sender){
        lpToken = _lpToken;
        treasury = _treasury;
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        lpToken.transferFrom(msg.sender, address(this), amount);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].rewardDebt += amount * rewardRate;
    }

    function unstake(uint256 amount) external {
        require(stakes[msg.sender].amount >= amount, "Insufficient stake");

        uint256 pendingReward = (stakes[msg.sender].amount * rewardRate) - stakes[msg.sender].rewardDebt;
        treasury.distributeRewards(msg.sender, pendingReward);

        stakes[msg.sender].amount -= amount;
        stakes[msg.sender].rewardDebt = stakes[msg.sender].amount * rewardRate;

        lpToken.transfer(msg.sender, amount);
    }

    function claimRewards() external {
        uint256 pendingReward = (stakes[msg.sender].amount * rewardRate) - stakes[msg.sender].rewardDebt;
        treasury.distributeRewards(msg.sender, pendingReward);

        stakes[msg.sender].rewardDebt = stakes[msg.sender].amount * rewardRate;
    }
}
