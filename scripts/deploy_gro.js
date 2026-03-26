// Add to scripts/deploy_gro.js (or create a new script)
const tx = await gro.mint(deployer.address, ethers.utils.parseEther("1000"));
await tx.wait();
console.log("Minted 1000 GRO to:", deployer.address);
