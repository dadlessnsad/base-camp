// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract BasicMath {

   function adder(uint _a, uint _b) public pure returns(uint sum, bool error) {
        // Check for overflow in max uint256 + 1
        if (type(uint).max - _a < _b) {
            return (0, true);
        } else {
            return (_a + _b, false);
        }
    }

    function subtractor(uint _a, uint _b) public pure returns(uint difference, bool error) {
        if (_a < _b) {
            return (0, true);
        } else {
            return (_a - _b, false);
        }
    }
}
