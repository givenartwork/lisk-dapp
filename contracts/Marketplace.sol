// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyNFT.sol";

contract Marketplace {
    struct Listing {
        address nftContract;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCounter;

    event Listed(uint256 indexed listingId, address indexed nftContract, uint256 indexed tokenId, address seller, uint256 price);
    event Sold(uint256 indexed listingId, address indexed buyer);
    event Canceled(uint256 indexed listingId);

    function listNFT(address _nftContract, uint256 _tokenId, uint256 _price) public {
        require(_price > 0, "Marketplace: Price must be greater than 0");

        MyNFT nft = MyNFT(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "Marketplace: You do not own this NFT");
        require(nft.getApproved(_tokenId) == address(this), "Marketplace: Contract not approved to spend this NFT");

        listingCounter++;
        listings[listingCounter] = Listing({
            nftContract: _nftContract,
            tokenId: _tokenId,
            seller: payable(msg.sender),
            price: _price,
            active: true
        });

        emit Listed(listingCounter, _nftContract, _tokenId, msg.sender, _price);
    }

    function buyNFT(uint256 _listingId) public payable {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Marketplace: Listing is not active");
        require(msg.value == listing.price, "Marketplace: Incorrect price");

        listing.active = false;

        MyNFT nft = MyNFT(listing.nftContract);
        nft.transferFrom(listing.seller, msg.sender, listing.tokenId);

        listing.seller.transfer(msg.value);

        emit Sold(_listingId, msg.sender);
    }

    function cancelListing(uint256 _listingId) public {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Marketplace: Listing is not active");
        require(listing.seller == msg.sender, "Marketplace: You are not the seller of this listing");

        listing.active = false;

        emit Canceled(_listingId);
    }
}
