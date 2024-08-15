pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NodeManagement is Ownable(msg.sender){
    struct NodeInformation{
        string name;
        string metadata;
        bool status;
    }
    uint nodeCount;
    mapping (uint NodeId => NodeInformation) public nodes;

    struct DiscountCoupon{
        bool status;
        uint discountPercent;
    }
    mapping (bytes32 code => DiscountCoupon) coupons;

    event _creatNode(uint indexed nodeId, string name, string metadata, bool status);
    event _updateNode(uint indexed nodeId, string name, string metadata, bool status);
    event _deleteNode(uint indexed nodeId);

    function creatNode(string memory name, string memory metadata, bool status) public onlyOwner{
        nodeCount ++;
        nodes[nodeCount] = NodeInformation(name, metadata, status);
        emit _creatNode(nodeCount, name, metadata, status);
    }
    function updateNode(uint nodeId, string memory name, string memory metadata, bool status) public onlyOwner{
        require(nodes[nodeId].status, "Node is not exsist");
        nodes[nodeId] = NodeInformation(name, metadata, status);
        emit _updateNode(nodeId, name, metadata, status);
    }
    function deleteNode(uint nodeId) public onlyOwner{
        require(nodes[nodeId].status, "Node is not exsist");
        delete(nodes[nodeId]);
        emit _deleteNode(nodeId);
    }
    function creatCoupon(string memory code, bool status, uint discountPercent) public onlyOwner{
        bytes32 codeCoupon = keccak256(abi.encodePacked(code));
        coupons[codeCoupon] = DiscountCoupon(status, discountPercent);
    }
    function updateCoupon(string memory code, bool status, uint discountPercent) public onlyOwner{
        bytes32 codeCoupon = keccak256(abi.encodePacked(code));
        require(coupons[codeCoupon].status, "Coupon is not exsit");
        coupons[codeCoupon] = DiscountCoupon(status, discountPercent);
    }
    function deleteCoupon(string memory code) public onlyOwner{
        bytes32 codeCoupon = keccak256(abi.encodePacked(code));
        require(coupons[codeCoupon].status, "Coupon is not exsit");
        delete(coupons[codeCoupon]);
    }
}