const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying GRO with account:", deployer.address);

  // Deploy GRO (upgradeable)
  const GRO = await ethers.getContractFactory("Gropesa");
  const gro = await upgrades.deployProxy(
    GRO,
    [deployer.address], // initializer args (owner)
    { initializer: "initialize" }
  );
  await gro.deployed();

  console.log("GRO deployed to:", gro.address);
  console.log("Proxy Admin Address:", await upgrades.erc1967.getAdminAddress(gro.address));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
// Add to scripts/deploy_gro.js (or create a new script)
const tx = await gro.mint(deployer.address, ethers.utils.parseEther("1000"));
await tx.wait();
console.log("Minted 1000 GRO to:", deployer.address);
