// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract WillContract {
    address public immutable i_owner;
    address private owner_inheritance;
    uint private amount;
    uint256 lastPing;

    constructor(address _inheritance) payable minEth {
        i_owner = msg.sender;
        owner_inheritance = _inheritance;
        amount += msg.value;
        lastPing = block.timestamp;
    }

    function changeInheritance(address _inheritance) public onlyOwner {
        owner_inheritance = _inheritance;
        lastPing = block.timestamp;
    }

    function deposit() public payable onlyOwner minEth {
        
        amount += msg.value;
        lastPing = block.timestamp;
    }

    function ping() public onlyOwner {
        lastPing = block.timestamp;
    }

    function withDraw() public payable {
        require(msg.sender == owner_inheritance, "Can only be called by owner inheritance");
        require(block.timestamp - lastPing >= 31622400, "Can only be called once after 1 years");
        
        payable(owner_inheritance).transfer(amount);
        amount = 0;
    }

    modifier onlyOwner() {
        require (msg.sender == i_owner, "Only owner can modify");
        _;
    }

    modifier minEth() {
        require(msg.value >= 1e18, "Not enough ether provided");
        _;
    }
}

contract UserContract {

    WillContract[] public willContracts;

    constructor() {
        WillContract willContract = new WillContract(address(0x3c15974a86f));
        willContracts.push(willContract);
    }
}