const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const admin = await ethers.deployContract("Admin");
  console.log("Admin: ", await admin);

  // const supplier = await ethers.deployContract("Supplier");
  // console.log("Supplier: ", await supplier);


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
