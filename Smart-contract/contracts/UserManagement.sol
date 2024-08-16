pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UserManagement is Ownable(msg.sender){
    mapping (address => string) public userURIs;

    function setUserURI(string memory URI, address user) public onlyOwner{
        userURIs[user] = URI;
    }
}