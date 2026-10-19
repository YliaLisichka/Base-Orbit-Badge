const hre = require("hardhat");
async function main() {
  const Badge = await hre.ethers.getContractFactory("OrbitBadge");
  const badge = await Badge.deploy();
  await badge.deployed();
  console.log("OrbitBadge deployed to:", badge.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
