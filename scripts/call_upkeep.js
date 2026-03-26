// scripts/call_upkeep.js
const { ethers } = require("hardhat");
async function main() {
  const gro = await ethers.getContractAt("Gropesa", "0xYourGROAddress");
  const tx = await gro.performUpkeep();
  await tx.wait();
  console.log("Upkeep performed!");
}
main();
