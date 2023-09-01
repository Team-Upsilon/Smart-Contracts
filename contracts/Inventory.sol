// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Inventory {

    struct RawMaterial {
        uint256 materialId;
        string name;
        string description; 
        string ipfs_hash; 
        uint256 quantity;
    }

    uint256 public materialCount;
    mapping(uint256 => RawMaterial) public rawMaterials;

    function addRawMaterial(
        string memory _name,
        string memory _description,
        string memory _ipfs_hash,
        uint256 _quantity
    ) external {
        materialCount++;
        rawMaterials[materialCount] = RawMaterial(
            materialCount,
            _name,
            _description,
            _ipfs_hash,
            _quantity
        );
    }

    function checkAvailability(
        uint256 _materialId,
        uint256 _desiredQuantity
    ) external view returns (uint256) {
        RawMaterial storage material = rawMaterials[_materialId];
        require(material.materialId != 0, "Material not found");

        if (material.quantity >= _desiredQuantity) {
            return _desiredQuantity;
        } else {
            return 0;
        }
    }

    function increaseQuantity(
        uint256 _materialId,
        uint256 _additionalQuantity
    ) external {
        RawMaterial storage material = rawMaterials[_materialId];
        require(material.materialId != 0, "Material not found");

        material.quantity += _additionalQuantity;
    }

    function decreaseQuantity(
        uint256 _materialId,
        uint256 _quantityToDeduct
    ) external {
        RawMaterial storage material = rawMaterials[_materialId];
        require(material.materialId != 0, "Material not found");
        require(
            material.quantity >= _quantityToDeduct,
            "Insufficient quantity"
        );

        material.quantity -= _quantityToDeduct;
    }

    function updateRawMaterial(
        uint256 _materialId,
        string memory _newName,
        string memory _newDescription,
        string memory _newIpfsHash,
        uint256 _newQuantity
    ) external {
        RawMaterial storage material = rawMaterials[_materialId];
        require(material.materialId != 0, "Material not found");

        material.name = _newName;
        material.description = _newDescription;
        material.ipfs_hash = _newIpfsHash;
        material.quantity = _newQuantity;
    }
}
