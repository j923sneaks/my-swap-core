// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "../SwapRequestState.sol";

// data for display
struct SwapDetails {
    address swapWith; // owner1 or owner2 depending on function call
    address swapAddress;
    address token1;
    address token2;
    uint amount1;
    uint amount2;
    uint timeStarted;
    uint timeEnded;
    SwapRequestState state;
}