// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {FavoriteRecords} from "../src/FavoriteRecords.sol";

contract CounterTest is Test {
    FavoriteRecords public favoriteRecords;

    function setUp() public {
        favoriteRecords = new FavoriteRecords();
    }

    function test_ApprovedRecords() public {
        string[] memory approvedRecords = favoriteRecords.getApprovedRecords();
        assertTrue(approvedRecords.length == 9);
        assertEq(approvedRecords[0], "Thriller");
        assertEq(approvedRecords[1], "Back in Black");
        assertEq(approvedRecords[2], "The Bodyguard");
        assertEq(approvedRecords[3], "The Dark Side of the Moon");
        assertEq(approvedRecords[4], "Their Greatest Hits (1971-1975)");
        assertEq(approvedRecords[5], "Hotel California");
        assertEq(approvedRecords[6], "Come On Over");
        assertEq(approvedRecords[7], "Rumours");
        assertEq(approvedRecords[8], "Saturday Night Fever");
    }

    function test_UserFavorites() public {
        favoriteRecords.addRecord("Thriller");
        favoriteRecords.addRecord("Back in Black");
        favoriteRecords.addRecord("The Bodyguard");
        favoriteRecords.addRecord("The Dark Side of the Moon");
        favoriteRecords.addRecord("Their Greatest Hits (1971-1975)");
        favoriteRecords.addRecord("Hotel California");
        favoriteRecords.addRecord("Come On Over");
        favoriteRecords.addRecord("Rumours");
        favoriteRecords.addRecord("Saturday Night Fever");

        string[] memory userFavorites = favoriteRecords.getUserFavorites(address(this));
        assertTrue(userFavorites.length == 9);
        assertEq(userFavorites[0], "Thriller");
        assertEq(userFavorites[1], "Back in Black");
        assertEq(userFavorites[2], "The Bodyguard");
        assertEq(userFavorites[3], "The Dark Side of the Moon");
        assertEq(userFavorites[4], "Their Greatest Hits (1971-1975)");
        assertEq(userFavorites[5], "Hotel California");
        assertEq(userFavorites[6], "Come On Over");
        assertEq(userFavorites[7], "Rumours");
        assertEq(userFavorites[8], "Saturday Night Fever");
    }

    function test_ResetUserFavorites() public {
        favoriteRecords.addRecord("Thriller");
        favoriteRecords.addRecord("Back in Black");
        favoriteRecords.addRecord("The Bodyguard");
        favoriteRecords.addRecord("The Dark Side of the Moon");
        favoriteRecords.addRecord("Their Greatest Hits (1971-1975)");
        favoriteRecords.addRecord("Hotel California");
        favoriteRecords.addRecord("Come On Over");
        favoriteRecords.addRecord("Rumours");
        favoriteRecords.addRecord("Saturday Night Fever");

        string[] memory userFavorites = favoriteRecords.getUserFavorites(address(this));
        assertTrue(userFavorites.length == 9);
        assertEq(userFavorites[0], "Thriller");
        assertEq(userFavorites[1], "Back in Black");
        assertEq(userFavorites[2], "The Bodyguard");
        assertEq(userFavorites[3], "The Dark Side of the Moon");
        assertEq(userFavorites[4], "Their Greatest Hits (1971-1975)");
        assertEq(userFavorites[5], "Hotel California");
        assertEq(userFavorites[6], "Come On Over");
        assertEq(userFavorites[7], "Rumours");
        assertEq(userFavorites[8], "Saturday Night Fever");
        favoriteRecords.resetUserFavorites();

        userFavorites = favoriteRecords.getUserFavorites(address(this));
        assertTrue(userFavorites.length == 0);
    }

    function testFailNotApprovedRec() public {
        favoriteRecords.addRecord("Billy Talent");
    }


}
