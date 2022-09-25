// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ATNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private supply;

    constructor() ERC721("Ayush Thakur", "ATNFT"){ //constant param reduces gas
    }

    function mint(string memory _tokenURI) external payable returns(uint256) {
        require(msg.value > 0.5 ether, "0.5 eth is required to mint.");
        supply.increment();

        uint256 tokenId = supply.current();
        _mint(msg.sender,tokenId);

        _setTokenURI(tokenId, _tokenURI);

        return tokenId;
    }

}