// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract SwapRequestOld {
    IERC20 token1;
    IERC20 token2;
    address owner1;
    address owner2;
    uint amount1;
    uint amount2;

    modifier onlyOwner2() {
        require(msg.sender == owner2, "Not authorized to perform swap");
        _;
    }

    constructor(address _token1, address _token2, address _owner2, uint _amount1, uint _amount2) public {
        require(msg.sender != _owner2, "Cannot swap to yourself");

        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        owner1 = msg.sender;
        owner2 = _owner2;
        amount1 = _amount1;
        amount2 = _amount2;
    }

    function swap() onlyOwner2 public {
        require(token1.balanceOf(owner1) >= amount1, "Owner 1 has insufficient funds");
        require(token2.balanceOf(owner2) >= amount2, "Owner 2 has insufficient funds");

        bool transferA = token1.transferFrom(owner1, owner2, amount1);
        bool transferB = token2.transferFrom(owner2, owner1, amount2);

        require(transferA && transferB, "Swap failed");
    }
}