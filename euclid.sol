// SPDX-License-Identifier: GPL-3.0

/* 

This program contains a helper library that will allow us to
compute the Euclidean distance between two points.

Note that floating point values are not supported in solidity 
so the square root function will only be an approximation
of the input value.

*/

pragma solidity >= 0.8.0 < 0.9.0;

library Euclid{
    
    function abs(int x) private pure returns (int) {
        // Calculate the absolute value of an integer, if it
        // is greater than or equal to zero then return itself
        // otherwise negate it and return that value
        if(x >= 0){
            return x;
        }
        else return -x;
    }

    function sqrt(int n) private pure returns (int y){
        // Approximate the square root of a number using
        // the Babylonian method
        // Note that the process of doing this was found in
        // https://github.com/ethereum/dapp-bin/pull/50
        int x = (n + 1) / 2;
        y = n;
        while(x < y){
            y = x;
            x = (n /x + x) / 2;
        }
        return y;
    }
    
    function distance(int _x1, int _y1, int _x2, int _y2) public pure returns (int){
        // Compute the euclidean distance between two points
        int d = abs((_x2 - _x1)**2 + (_y2 - _y1)**2);
        int di = sqrt(d);
        return di;
    }

}

