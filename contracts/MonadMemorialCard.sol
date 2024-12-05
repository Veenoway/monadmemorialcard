// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MemorialCardCollection is ERC721URIStorage {
    uint256 public nextTokenId; 
    address public owner; 
    bytes32 private secretHash; 
    uint256 public constant MAX_SUPPLY = 10001;

    mapping(address => bool) public hasMinted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() ERC721("MemorialCardCollection", "CNFT") {
        owner = msg.sender; 
        nextTokenId = 1;
        secretHash = 0xea3a2f73268431eaae404d7bcff83c617031d183f689a1d7f8e3f48243b15e14; 
    }

    function mint(address recipient, string memory tokenURI, string memory providedSecret) public {
        require(keccak256(abi.encodePacked(providedSecret)) == secretHash, "Invalid secret");
        require(!hasMinted[recipient], "This address has already minted a token");
        require(nextTokenId <= MAX_SUPPLY, "Maximum supply of 10,000 tokens reached");
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
         hasMinted[recipient] = true;
    }
}
