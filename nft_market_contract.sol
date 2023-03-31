// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC721 standard from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {
    address payable public owner;
    uint256 public price;
    uint256 public tokenId;
    mapping (uint256 => bool) public tokenForSale;

    constructor() ERC721("MyNFT", "NFT") {
        owner = payable(msg.sender);
        price = 1 ether; // set the price to 1 ether
    }

    // Mint a new NFT
    function mintNFT() public {
        require(msg.sender == owner, "Only the owner can mint NFTs");
        tokenId++;
        _safeMint(msg.sender, tokenId);
    }

    // Set the price for the NFT
    function setPrice(uint256 _price) public {
        require(msg.sender == owner, "Only the owner can set the price");
        price = _price;
    }

    // Put the NFT up for sale
    function putForSale(uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "Only the owner can put the NFT up for sale");
        require(tokenForSale[_tokenId] == false, "The NFT is already up for sale");
        tokenForSale[_tokenId] = true;
    }

    // Buy the NFT
    function buyNFT(uint256 _tokenId) public payable {
        require(tokenForSale[_tokenId] == true, "The NFT is not for sale");
        require(msg.value >= price, "Insufficient funds");
        address payable seller = payable(ownerOf(_tokenId));
        transferFrom(seller, msg.sender, _tokenId);
        seller.transfer(msg.value);
        tokenForSale[_tokenId] = false;
    }

    // Withdraw funds from the contract
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        uint256 balance = address(this).balance;
        owner.transfer(balance);
    }
}
