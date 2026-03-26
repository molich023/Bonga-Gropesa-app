// scripts/deploy.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy GRO Token
  const GRO = await ethers.getContractFactory("Gropesa");
  const gro = await upgrades.deployProxy(
    GRO,
    [deployer.address], // Initial owner
    { initializer: "initialize" }
  );
  await gro.deployed();
  console.log("GRO deployed to:", gro.address);

  // Deploy Redemption Contract
  const Redemption = await ethers.getContractFactory("GropesaRedemption");
  const redemption = await upgrades.deployProxy(
    Redemption,
    [gro.address], // GRO token address
    { initializer: "initialize" }
  );
  await redemption.deployed();
  console.log("Redemption deployed to:", redemption.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
