// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

// data for display
struct TokenDetails {
    address tokenAddress; // in case frontend need to instantiate and perform erc20 functions
    string symbol; // include this so frontend wont have to instantiate token contract
    uint amount;
}