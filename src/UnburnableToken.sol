// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract UnburnableToken {
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address);


    uint public totalSupply;
    uint public totalClaimed;

    mapping(address => uint) public balances;
    mapping(address => bool) public hasClaimed;
    

    constructor() {
        totalSupply = 100000000;
    }
    
    function claim() public {
        if (hasClaimed[msg.sender]) revert TokensClaimed();
        if (totalClaimed + 1000 > totalSupply) revert AllTokensClaimed();
        hasClaimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint _amount) public {
        if (_to == address(0)) revert UnsafeTransfer(_to);
        if (balances[msg.sender] < _amount) revert UnsafeTransfer(_to);
        uint etherBalance = _to.balance;
        if (etherBalance == 0) revert UnsafeTransfer(_to);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

}
