// test/Gropesa.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Gropesa", function () {
  let Gropesa, gro, owner, user1, user2;

  beforeEach(async () => {
    [owner, user1, user2] = await ethers.getSigners();
    const GropesaFactory = await ethers.getContractFactory("Gropesa");
    gro = await GropesaFactory.deploy();
    await gro.mint(user1.address, ethers.utils.parseEther("1000"));
    await gro.mint(user2.address, ethers.utils.parseEther("1000"));
  });

  it("Should stake GRO", async function () {
    await gro.connect(user1).stake(ethers.utils.parseEther("100"), 30);
    const stake = await gro.stakes(user1.address);
    expect(stake.amount).to.equal(ethers.utils.parseEther("100"));
  });

  it("Should calculate rewards", async function () {
    await gro.connect(user1).stake(ethers.utils.parseEther("100"), 30);
    await ethers.provider.send("evm_increaseTime", [30 * 86400]); // 30 days
    const reward = await gro.calculateReward(user1.address);
    expect(reward).to.be.gt(0);
  });

  it("Should unstake with penalty", async function () {
    await gro.connect(user1).stake(ethers.utils.parseEther("100"), 30);
    await ethers.provider.send("evm_increaseTime", [15 * 86400]); // 15 days (early)
    await expect(gro.connect(user1).unstake())
      .to.emit(gro, "Transfer") // Penalty applied
      .withArgs(gro.address, user1.address, ethers.utils.parseEther("90")); // 100 - 10% penalty
  });
});
