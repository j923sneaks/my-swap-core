// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "../SwapRequestState.sol";
import "./TokenDetails.sol";

// data for display
struct SwapDetails {
    address swapWith; // owner1 or owner2 depending on function call
    address swapAddress;
    TokenDetails token1;
    TokenDetails token2;
    uint timeStarted;
    uint timeEnded;
    SwapRequestState state;
}