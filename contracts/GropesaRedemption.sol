// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts/access/OwnableUpgradeable.sol";

contract GropesaRedemption is OwnableUpgradeable {
    address public gropesaToken;
    uint256 public redemptionRate = 100; // 100 GRO = 1 unit (e.g., 50 KES airtime)
    mapping(address => bool) public isKYCVerified;

    constructor(address _gropesaAddress) {
        gropesaToken = _gropesaAddress;
    }

    function setKYCStatus(address user, bool status) external onlyOwner {
        isKYCVerified[user] = status;
    }

    function redeem(uint256 amount) external {
        require(isKYCVerified[msg.sender], "KYC required");
        require(ERC20(gropesaToken).balanceOf(msg.sender) >= amount, "Insufficient GRO");
        ERC20(gropesaToken).transferFrom(msg.sender, address(this), amount);
        // Call PSP API (off-chain)
        emit RedemptionRequested(msg.sender, amount);
    }

    function setRedemptionRate(uint256 newRate) external onlyOwner {
        redemptionRate = newRate;
    }
}
