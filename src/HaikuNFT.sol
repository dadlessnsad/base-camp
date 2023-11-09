// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }
    Haiku[] public haikus;
    
    uint256 public counter = 1;
    
    // address => to array of haikuIds
    mapping(address => uint256[]) public sharedHaikus;
    mapping(string => bool) public haikuExists;
    
    error HaikuNotUnique();
    error NoHaikusShared();
    error NotOwnerOf();

    constructor() ERC721("HaikuNFT", "HAIKU") {
        haikus.push();
    }
    

    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        if (haikuExists[_line1] || haikuExists[_line2] || haikuExists[_line3]) revert HaikuNotUnique();
        haikuExists[_line1] = true;
        haikuExists[_line2] = true;
        haikuExists[_line3] = true;

        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        _safeMint(msg.sender, counter);
        counter++;
    }

    function shareHaiku(uint256 _haikuId, address _to) external {
        if (msg.sender != ownerOf(_haikuId)) revert NotOwnerOf();
        sharedHaikus[_to].push(_haikuId);
    }


    function getMySharedHaikus() external view returns (Haiku[] memory) {
        uint256[] storage haikuIds = sharedHaikus[msg.sender];
        if (haikuIds.length == 0) revert NoHaikusShared();

        Haiku[] memory haikusShared = new Haiku[](haikuIds.length);
        for (uint256 i = 0; i < haikuIds.length; i++) {
            haikusShared[i] = haikus[haikuIds[i]];
        }
        return haikusShared;
    }







}
