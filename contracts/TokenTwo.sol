// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./MyToken.sol";

contract TokenTwo is MyToken {
    constructor() MyToken("Two", "TWO") {}
}