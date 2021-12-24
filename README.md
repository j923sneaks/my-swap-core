## TRUFFLE CONSOLE

### note: change SwapRequestOld functions to public before testing

1. truffle migrate --reset
2. get token1 and token2 addresses and call faucet
    - token = await TokenTwo.deployed()
    - token.faucet({ from: <address> })
3. instaniate contract via ABI
    - requestSwap = new web3.eth.Contract(<SwapRequestOld.abi>)
4. deploy contract
    - SwapRequestOld = await requestSwap.deploy({ data: SwapRequestOld.bytecode, arguments: [<token1Addr>, <token2Addr>, <owner2>, <amount1>, <amount2>] }).send({ from: <owner1>, gas: <gas more than limit> })
5. approve contract as spender of owner's token
    - await token1.approve(<SwapRequestOld address>, <amount1>).send({ from: <owner1> })
    - await token2.approve(<SwapRequestOld address>, <amount2>).send({ from: <owner2> })
6. execute swap from owner2
    - await SwapRequestOld.methods.swap().send({ from: <owner2>, gas: <gas more than limit> })

## TODO

- decimal arguments
- forfeit function
- Selfdestruct contract or add state to prevent reuse???
- Frontend work
- Use estimate ga