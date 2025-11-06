// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract MyNFT is ERC721 {
    uint256 private _tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") {
        _tokenIdCounter = 0;
    }

    function mint(address to) public returns (uint256) {
        _tokenIdCounter++;
        _mint(to, _tokenIdCounter);
        return _tokenIdCounter;
    }
}
