// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DogNFT is ERC721A , AccessControl{
    using Strings for uint256;
    uint256 public constant MAX_SUPPLY = 20;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 internal START_TOKEN_ID ;
    string public baseURI;
    string internal baseExtension = ".json";
    bytes32 internal constant Controller = keccak256("Controller");

    address public immutable owner;

    /**
     * @dev Constructor function
     */
    constructor() ERC721A("PupPixel", "PPX") {
        owner = msg.sender;
        _tokenIdCounter.increment();
        START_TOKEN_ID = _tokenIdCounter.current();
        _grantRole(Controller, msg.sender);
    }

    /**
     * @dev Returns the token ID
     * @return uint256 token ID
     * override start token id
     */
     function _startTokenId() internal view virtual override returns (uint256) {
        return START_TOKEN_ID;
    }


    function mint() external payable onlyRole(Controller){
        require(
            totalSupply()+1 <= MAX_SUPPLY,
            "Capybara: exceed max supply"
        );
        _mint(msg.sender, 1);
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

    function setBaseURI(string memory _newBaseURI) external onlyRole(Controller) {
        baseURI = _newBaseURI;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721A, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
