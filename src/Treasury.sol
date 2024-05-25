// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Treasury is Ownable {
    IERC20 public rewardToken;

    constructor(IERC20 _rewardToken) Ownable(msg.sender) {
        rewardToken = _rewardToken;
    }

    function distributeRewards(address to, uint256 amount) external onlyOwner {
        rewardToken.transfer(to, amount);
    }

    function withdrawReward(uint256 amount) external onlyOwner {
        rewardToken.transfer(msg.sender, amount);
    }

    // function depositFee(uint256 amount) external onlyOwner {
    //     rewardToken.transferFrom(msg.sender, address(this), amount);
    // }

    // function withdrawFee(uint256 amount) external onlyOwner {
    //     rewardToken.transfer(msg.sender, amount);
    // }

}