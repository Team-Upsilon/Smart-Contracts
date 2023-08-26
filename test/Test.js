const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require('ethers')

describe("Supplier Contract", function () {
  let adminContract;
  let inventoryContract;
  let supplierContract;

  beforeEach(async function () {

    const Admin = await ethers.getContractFactory("Admin");
    const adminContract = await Admin.deploy();
    // await adminContract.deployed();

    console.log("Admin: ", adminContract)
    
    const Inventory = await ethers.getContractFactory("Inventory");
    inventoryContract = await Inventory.deploy(adminContract.target);

    const Supplier = await ethers.getContractFactory("Supplier");
    supplierContract = await Supplier.deploy(
      inventoryContract.target,
      adminContract.target
    );

  });


  it("should request a raw material package", async function () {
    // Add a supplier to the admin contract
    console.log("Admin: ", adminContract)
    await adminContract.addSupplier(0xE8Dc9F3cecc1E7DD7737001f1987cc2813246A93);

    // Add raw material to the inventory contract
    const materialId = 1;
    await inventoryContract.addRawMaterial("Material 1", "Description 1", "IPFS Hash 1", 100);

    // Request a raw material package
    await supplierContract.requestRawMaterialPackage(
      [materialId],
      [50],
      "Sample Description",
      "0x0000000000000000000000000000000000000000",  // manufacturerId
      "0x0000000000000000000000000000000000000000",  // transporterId
      supplierContract.target,  // supplierId
      "0x0000000000000000000000000000000000000000"  // inspectorId
    );

    // Get the created package
    const createdPackage = await supplierContract.getRawMaterialPackage(1);

    // Assertions
    expect(createdPackage.packageId).to.equal(1);
    expect(createdPackage.rawMaterialsIds).to.deep.equal([materialId]);
    expect(createdPackage.rawMaterialsQuantities[materialId].toString()).to.equal("50");
    expect(createdPackage.description).to.equal("Sample Description");

  });


});
