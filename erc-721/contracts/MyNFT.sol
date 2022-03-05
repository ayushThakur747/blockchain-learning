// SPDX-License-Identifier: MIT
pragma  solidity 0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; //for storing metadata

contract MyNFT is ERC721, ERC721Enumerable, Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public mintRate = 0.01 ether;
    uint256 public MAX_SUPPLY = 1000;

    constructor() ERC721("MyNFT", "MNFT") {} //assiging name and symbol of our nft, using ERC721 class constructor

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function safeMint(address to, string memory _tokenURI) public payable{
        //require(totalSupply() < MAX_SUPPLY, "max nfts minted already");
        require(msg.value >= mintRate, "Not enough ether sent");
        _tokenIdCounter.increment();
        _safeMint(to, _tokenIdCounter.current()); //mint first and then set token uri
        _setTokenURI(_tokenIdCounter.current(), _tokenURI);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    } 

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

       function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }



    //other functions
    function withdraw() public onlyOwner{
        require(address(this).balance >0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
}
