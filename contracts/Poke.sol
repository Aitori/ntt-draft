// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "./PokeRoles.sol";

contract Poke is ERC721EnumerableUpgradeable, PausableUpgradeable, PokeRoles {
    event ExperienceToken(uint256 eventId, uint256 tokenId);
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Base token URI
    string private _baseURI;

    // latest token id
    uint256 private lastId;

    // mapping for "experience"
    mapping(uint256 => uint256) private _experienceTokens;

    function initalize(string memory __name, string memory __symbol)
        public
        initializer
    {
        __ERC721_init(__name, __symbol);
        __ERC721Enumerable_init();
        PokeRoles.initialize(msg.sender);
        __Pausable_init();
    }

    /**
     * @dev Gets the token with specified id
     * @return string eventid
     */
    function experienceTokens(uint256 tokenId) public view returns (uint256) {
        return _experienceTokens[tokenId];
    }

    /**
     * @dev Returns given token id of an owner's set of tokens
     * @param owner address owning the tokens list to be accessed
     * @param index uint256 representing the index to be accessed of the requested tokens list
     * @return tokenId at the given index of the tokens list owned by the requested address
     */
    function tokenDetailsOfOwnerByIndex(address owner, uint256 index)
        public
        view
        returns (uint256 tokenId)
    {
        tokenId = tokenOfOwnerByIndex(owner, index);
    }

    function setBaseURI(string memory baseURI) public onlyAdmin whenNotPaused {
        _baseURI = baseURI;
    }

    function approve(address to, uint256 tokenId)
        public
        override(ERC721Upgradeable, IERC721Upgradeable)
        whenNotPaused
    {
        super.approve(to, tokenId);
    }

    function setApprovalForAll(address to, bool approved)
        public
        override(ERC721Upgradeable, IERC721Upgradeable)
        whenNotPaused
    {
        super.setApprovalForAll(to, approved);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721Upgradeable, IERC721Upgradeable) whenNotPaused {
        super.transferFrom(from, to, tokenId);
    }

    function mintToken(uint256 eventId, address to)
        public
        whenNotPaused
        returns (bool)
    {
        lastId += 1;
        return _mintToken(eventId, lastId, to);
    }

    function mintExperienceToManyUsers(uint256 eventId, address[] memory to)
        public
        whenNotPaused
        returns (bool)
    {
        for (uint256 i = 0; i < to.length; ++i) {
            _mintToken(eventId, lastId + 1 + i, to[i]);
        }
        lastId += to.length;
        return true;
    }

    function _mintToken(
        uint256 eventId,
        uint256 tokenId,
        address to
    ) internal returns (bool) {
        // TODO Verify that the token receiver ('to') do not have already a token for the event ('eventId')
        _mint(to, tokenId);
        _experienceTokens[tokenId] = eventId;
        emit ExperienceToken(eventId, tokenId);
        return true;
    }

    //override transfer for admins only for non transferrable
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override onlyAdmin whenNotPaused {
        super._transfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721EnumerableUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
