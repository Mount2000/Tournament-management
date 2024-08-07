pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import  "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTManagement is Ownable, ERC721URIStorage{
    uint  tokenCount; //token ID
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender){
    }
    function mint(string memory _URI, address minner) public  onlyOwner{
        tokenCount ++;
        _mint(minner, tokenCount);
        _setTokenURI(tokenCount, _URI);
    }
    function burn(uint tokenId) public {
        _burn(tokenId);
    }
}