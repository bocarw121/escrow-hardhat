// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Escrow {
    address public arbiter; // middleman
    address public beneficiary; // selling
    address public depositor; // buying

    bool public isApproved;

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;

        // arbiter should get  a 5% cut
        uint arbiterCut = (address(this).balance * 5) / 100;
        (bool cutSent, ) = payable(arbiter).call{value: arbiterCut}('');
        require(cutSent, 'Failed to send Ether');
    }

    event Approved(uint);

    function approve() external {
        require(msg.sender == arbiter);
        uint balance = address(this).balance;
        (bool sent, ) = payable(beneficiary).call{value: balance}('');
        require(sent, 'Failed to send Ether');
        emit Approved(balance);
        isApproved = true;
    }
}
