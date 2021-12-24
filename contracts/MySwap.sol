// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "./SwapRequest.sol";
import "./SwapRequestState.sol";
import "./struct/SwapDetails.sol";

contract MySwap {
    struct SwapsPerAddress {
        address[] initiatedSwaps;
        address[] pendingSwaps;
    }

    mapping(address => SwapsPerAddress) mySwaps;

    event SwapInitiated(address indexed _swapAddress, address _owner1, uint _timeStarted);
    event SwapFulfilled(address indexed _swapAddress, address _owner2, uint _timeEnded);
    event SwapForfeited(address indexed _swapAddress, address _owner1, uint _timeEnded);

    function initiateSwap(address _owner2, address _token1, address _token2, uint _amount1, uint _amount2) public returns(address) {
        SwapRequest swapRequest = new SwapRequest(msg.sender, _owner2, _token1, _token2, _amount1, _amount2);
        address swapAddress = address(swapRequest);

        mySwaps[msg.sender].initiatedSwaps.push(swapAddress);
        mySwaps[_owner2].pendingSwaps.push(swapAddress);

        emit SwapInitiated(swapAddress, msg.sender, block.timestamp);
        return swapAddress;
    }

    function fulfillSwap(address _swapAddress) public {
        SwapRequest(_swapAddress).swap(msg.sender);
        emit SwapFulfilled(_swapAddress, msg.sender, block.timestamp);
    }

    function forfeitSwap(address _swapAddress) public {
        SwapRequest(_swapAddress).forfeit(msg.sender);
        emit SwapForfeited(_swapAddress, msg.sender, block.timestamp);
    }

    function getInitiatedSwaps() public view returns(SwapDetails[] memory) {        
        return _processArray(mySwaps[msg.sender].initiatedSwaps, false);
    }

    function getPendingSwaps() public view returns(SwapDetails[] memory) {
        return _processArray(mySwaps[msg.sender].pendingSwaps, true);
    }

    function _processArray(address[] memory _swapRequests, bool isPending) private view returns(SwapDetails[] memory) {
        SwapDetails[] memory swapDetails = new SwapDetails[](_swapRequests.length);

        for (uint i = 0; i < _swapRequests.length; i += 1) {
            SwapRequest swapRequest = SwapRequest(_swapRequests[i]);

            // check SwapRequest.sol for order of returned values
            (
                SwapRequestState state, 
                address owner1, 
                address owner2, 
                address token1, 
                address token2, 
                uint amount1, 
                uint amount2, 
                uint timeStarted, 
                uint timeEnded
            ) = swapRequest.getDetails();

            swapDetails[i] = SwapDetails(
                isPending ? owner1 : owner2,
                address(swapRequest), // _swapRequests[i] throws CompileError: Stack too deep
                token1,
                token2,
                amount1,
                amount2,
                timeStarted,
                timeEnded,
                state
            );
        }

        return swapDetails;
    }
}