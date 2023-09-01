const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require('ethers')

describe("Write function testing", function () {
  let adminContract;
  let inventoryContract;

  beforeEach(async function () {

    const Admin = await ethers.getContractFactory("Admin");
    adminContract = await Admin.deploy();
    // await adminContract.deployed();

    // console.log("Admin: ", adminContract);
    
    const Inventory = await ethers.getContractFactory("Inventory");
    inventoryContract = await Inventory.deploy(adminContract.target);

    // console.log("Inventory: ", inventoryContract);

  });


 it("should write in smart contract", async function () {

    // Add a raw material
    await inventoryContract.addRawMaterial("Material 1", "Description 1", "ipfs_hash_1", 100);

    // Increase the quantity
    const materialId = 1;
    const additionalQuantity = 50;
    await inventoryContract.increaseQuantity(materialId, additionalQuantity);

    // Get the updated raw material
    const updatedMaterial = await inventoryContract.getRawMaterial(materialId);

    console.log("updatedMaterial: ", updatedMaterial);

    // Check the updated quantity
    // expect(updatedMaterial.quantity).to.equal(100 + additionalQuantity);

    // const count = await inventoryContract.Count();
    // console.log("count: ", count);
  }).timeout(1000000);
});
