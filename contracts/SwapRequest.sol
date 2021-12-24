// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "./SwapRequestState.sol";

contract SwapRequest {
    IERC20 token1;
    IERC20 token2;
    address owner1;
    address owner2;
    uint amount1;
    uint amount2;
    uint timeStarted;
    uint timeEnded;

    SwapRequestState state;

    modifier inState(SwapRequestState _state) {
        require(state == _state, "Error in contract state");
        _;
    }

    modifier endTime() {
        _;
        timeEnded = block.timestamp;
    }

    constructor(address _owner1, address _owner2, address _token1, address _token2, uint _amount1, uint _amount2) {
        require(_owner1 != _owner2, "Cannot swap with self");

        owner1 = _owner1;
        owner2 = _owner2;
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        amount1 = _amount1;
        amount2 = _amount2;
        state = SwapRequestState.OPEN;
        timeStarted = block.timestamp;
    }

    function swap(address _owner2) endTime inState(SwapRequestState.OPEN) external {
        require(_owner2 == owner2, "Not authorized to swap");
        require(token1.balanceOf(owner1) >= amount1, "Owner 1 has insufficient funds");
        require(token2.balanceOf(owner2) >= amount2, "Owner 2 has insufficient funds");

        bool transferA = token1.transferFrom(owner1, owner2, amount1);
        bool transferB = token2.transferFrom(owner2, owner1, amount2);

        require(transferA && transferB, "Swap failed");

        state = SwapRequestState.FULFILLED;
    }

    function forfeit(address _owner1) endTime inState(SwapRequestState.OPEN) external {
        require(_owner1 == owner1, "Not authorized to forfeit");

        state = SwapRequestState.FORFEITED;
    }

    function getDetails() public view returns(SwapRequestState, address, address, address, address, uint, uint, uint, uint) {
        return (state, owner1, owner2, address(token1), address(token2), amount1, amount2, timeStarted, timeEnded);
    }
}