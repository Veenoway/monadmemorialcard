// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MemorialCardCollection is ERC721URIStorage {
    uint256 public nextTokenId; 
    address public owner; 
    bytes32 private secretHash; 
    uint256 public constant MAX_SUPPLY = 10001;

    error InvalidSecret();
    error AlreadyMinted();
    error MaxSupplyReached();

    mapping(address => bool) public hasMinted;

    modifier onlyOwner() {
        if (msg.sender != owner) revert("Not owner");
        _;
    }

    constructor() ERC721("MemorialCardCollection", "CNFT") {
        owner = msg.sender; 
        nextTokenId = 1;
        secretHash = 0xea3a2f73268431eaae404d7bcff83c617031d183f689a1d7f8e3f48243b15e14; 
    }

    function mint(address recipient, string memory tokenURI, string memory providedSecret) public {
        // Handle errors
        if (keccak256(abi.encodePacked(providedSecret)) != secretHash) revert InvalidSecret();
        if (hasMinted[recipient]) revert AlreadyMinted();
        if (nextTokenId > MAX_SUPPLY) revert MaxSupplyReached();
        
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
         hasMinted[recipient] = true;
    }
}
