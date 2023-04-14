// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DogNFT is ERC721A{
    using Strings for uint256;
    uint256 public constant MAX_SUPPLY = 20;
    uint256 public constant START_TOKEN_ID = 1;

    string public baseURI;
    string internal baseExtension = ".json";

    address public immutable owner;
    modifier onlyOwner() {
        require(owner == msg.sender, "Capybara: not owner");
        _;
    }

    /**
     * @dev Constructor function
     */
    constructor() ERC721A("Capybara NFT", "CAPY") {
        owner = msg.sender;
    }

    /**
     * @dev Returns the token ID
     * @return uint256 token ID
     * override start token id
     */
    function _startTokenId() internal view virtual override returns (uint256) {
        return START_TOKEN_ID;
    }

    function mint(uint256 quantity) public payable {
        require(
            totalSupply() + quantity <= MAX_SUPPLY,
            "Capybara: exceed max supply"
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

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
}
