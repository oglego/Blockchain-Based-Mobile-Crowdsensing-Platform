// SPDX-License-Identifier: GPL-3.0

/* 

This program tests the Euclid helper Library functionality.

*/

pragma solidity >= 0.8.0 < 0.9.0;

import "./euclid.sol";

contract euclid_test {

    using Euclid for *;
    
    function distance(int _x1, int _y1, int _x2, int _y2) public pure returns (int){
        return Euclid.distance(_x1, _y1, _x2, _y2);
    }
}