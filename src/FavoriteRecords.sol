// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract FavoriteRecords {

    string[] public approvedRecordNames;
    
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) public userFavorites;
    mapping(address => string[]) public userFavoriteNames;  

    constructor() {
        string[] memory initialRecords = new string[](9);
        initialRecords[0] = "Thriller";
        initialRecords[1] = "Back in Black";
        initialRecords[2] = "The Bodyguard";
        initialRecords[3] = "The Dark Side of the Moon";
        initialRecords[4] = "Their Greatest Hits (1971-1975)";
        initialRecords[5] = "Hotel California";
        initialRecords[6] = "Come On Over";
        initialRecords[7] = "Rumours";
        initialRecords[8] = "Saturday Night Fever";

        for (uint256 i = 0; i < initialRecords.length; i++) {
            approvedRecords[initialRecords[i]] = true;
            approvedRecordNames.push(initialRecords[i]);
        }
    }

    error NotApproved(string name);

    function addRecord(string memory name) public {
        if (!approvedRecords[name]) {
            revert NotApproved(name);
        }

        if (!userFavorites[msg.sender][name]) {
            userFavorites[msg.sender][name] = true;
            userFavoriteNames[msg.sender].push(name);
        }
    }

    // Function to reset user favorites
    function resetUserFavorites() public {
        string[] storage favorites = userFavoriteNames[msg.sender];
        for (uint256 i = 0; i < favorites.length; i++) {
            userFavorites[msg.sender][favorites[i]] = false;
        }
        delete userFavoriteNames[msg.sender];
    }

    // Function to get approved records
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordNames;
    }

    // Function to get user favorites
    function getUserFavorites(address user) public view returns (string[] memory) {
        return userFavoriteNames[user];
    }
    
}
