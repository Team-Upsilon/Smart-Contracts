const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const Admin = await ethers.deployContract("Admin");
  console.log("Admin: ", await Admin.target);

  const Inventory = await ethers.deployContract("Inventory", [Admin.target]);
  console.log("Inventory: ", await Inventory.target);

  const Supplier = await ethers.deployContract("Supplier", [Inventory.target, Admin.target]);
  console.log("Supplier: ", await Supplier.target);

  const BatchScheduler = await ethers.deployContract("BatchScheduler");
  console.log("BatchScheduler: ", await BatchScheduler.target);

  const Manufacturer = await ethers.deployContract("Manufacturer", [BatchScheduler.target, Admin.target]);
  console.log("Manufacturer: ", await Manufacturer.target);

  const Inspector = await ethers.deployContract("Inspector", [Supplier.target, Admin.target]);
  console.log("Inspector: ", await Inspector.target);

  const Transporter = await ethers.deployContract("Transporter", [Supplier.target, Manufacturer.target, Admin.target]);
  console.log("Transporter: ", await Transporter.target);

  const RealTimeMonitoring = await ethers.deployContract("RealTimeMonitoring", [Manufacturer.target, Admin.target]);
  console.log("RealTimeMonitoring: ", await RealTimeMonitoring.target);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
