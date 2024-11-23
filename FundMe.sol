// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { PriceConverter } from "./PriceConverter.sol";


contract FundMe {
    using PriceConverter for uint256;
    address public i_owner;
    uint256 public minimumUsd = 5e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountContributed;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // msg.value.getConvertionRate();
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough eth");
        funders.push(msg.sender);
        addressToAmountContributed[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountContributed[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not owner value");
        _;
    }
}