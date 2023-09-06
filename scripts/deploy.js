const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const Admin = await ethers.deployContract("Admin");
  console.log("Admin: ", Admin.target);

  const Inventory = await ethers.deployContract("Inventory");
  console.log("Inventory: ", Inventory.target);

  const Supplier = await ethers.deployContract("Supplier", [Inventory.target]);
  console.log("Supplier: ", Supplier.target);

  const BatchScheduler = await ethers.deployContract("BatchScheduler");
  console.log("BatchScheduler: ", BatchScheduler.target);

  const Manufacturer = await ethers.deployContract("Manufacturer", [BatchScheduler.target]);
  console.log("Manufacturer: ", Manufacturer.target);

  const Inspector = await ethers.deployContract("Inspector", [Supplier.target]);
  console.log("Inspector: ", Inspector.target);

  const Transporter = await ethers.deployContract("Transporter", [Supplier.target, Manufacturer.target]);
  console.log("Transporter: ", Transporter.target);

  const RealTimeMonitoring = await ethers.deployContract("RealTimeMonitoring", [Manufacturer.target]);
  console.log("RealTimeMonitoring: ", RealTimeMonitoring.target);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
