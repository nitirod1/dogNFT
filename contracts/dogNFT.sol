// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DogNFT is ERC721A , Ownable{
    using Strings for uint256;
    uint256 public constant MAX_SUPPLY = 20;

    uint256 internal START_TOKEN_ID ;
    string public baseURI;
    string internal baseExtension = ".json";

    /**
     * @dev Constructor function
     */
    constructor() ERC721A("PupPixel", "PPX") {
        START_TOKEN_ID = 1;
    }

    /**
     * @dev Returns the token ID
     * @return uint256 token ID
     * override start token id
     */
     function _startTokenId() internal view virtual override returns (uint256) {
        return START_TOKEN_ID;
    }

    function mint(uint256 quantity) external payable onlyOwner{
        require(
            totalSupply()+quantity <= MAX_SUPPLY,
            "PupPixel: exceed max supply"
        );
        _mint(msg.sender, quantity);
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Capybara: not exist");
        string memory currentBaseURI = _baseURI();
        return (
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : ""
        );
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner{
        baseURI = _newBaseURI;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721A) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
