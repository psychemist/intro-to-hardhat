// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Crowdfunding {

    event CampaignCreated(address indexed creator, uint campaignId);
    event DonationReceived(uint campaignId, address indexed donor, uint amount);
    event CampaignEnded(uint campaignId, address beneficiary, bool goalMet);

    struct Campaign {
        string title; //name of campaign
        string description; // brief description of campaign
        address benefactor; // address of person or organization that created campaign
        address beneficiary; // address of person or organization to receive funds
        uint goal; // fundraising goal (in wei)
        uint deadline; // Unix timestamp when campaign ends (in seconds)
        uint amountRaised; // total amount of funds raised so far (in wei)
        bool ended; // campaign active/inactive boolean checker
    }

    Campaign[] campaigns;
    address owner;

    mapping(address => uint) balances;

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict functions to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action.");
        _;
    }

    // Create crowdfunding campaign
    function createCampaign(string memory _title, string memory _description, 
                            address _beneficiary, uint _goal, uint _duration) public {
        // Verify that campaign goal and duration are greater than zero
        require(_goal > 0);
        require(_duration > 0);

        // Calculate deadline from _duration parameter
        uint deadline = block.timestamp + _duration;

        // Create new campaign struct and aadd to campaigns array
        campaigns.push(Campaign(_title, _description, msg.sender, _beneficiary, _goal, deadline, 0, false));

        // Trigger campaign creation event
        emit CampaignCreated(msg.sender, campaigns.length - 1);
    }

    // Donate to crowdfunding campaign
    function donateToCampaign(uint _campaignId, uint _amount) public payable {
        Campaign storage campaign = campaigns[_campaignId];

        // Ensure that campaign is still open to donations
        require(campaign.deadline >= block.timestamp, "Crowdfunding deadline has passed!");

        // Update campaign balance
        campaign.amountRaised += _amount;
        balances[campaign.beneficiary] = campaign.amountRaised;

        // Trigger campaign donation event
        emit DonationReceived(_campaignId, msg.sender, _amount);
    }

    // Called internally to end campaign
    function _endCampaign(uint _campaignId) internal {
        Campaign storage campaign = campaigns[_campaignId];

        // Verify crowdfunding campaign is not ended
        require(!campaign.ended);

        // Transfer funds to beneficiary
        if (campaign.amountRaised > 0) {
            payable(campaign.beneficiary).transfer(campaign.amountRaised);
        }

        // End campaign
        campaign.ended = true;
    }


    function endCampaign(uint _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];

        // Verify only campaign creator can end the crowdfund
        require(msg.sender == campaign.benefactor);

        // Ensure campaign deadline has passed
        require(block.timestamp >= campaign.deadline, "Crowdfunding is still active!");

        // End campaign
        _endCampaign(_campaignId);

        // Trigger campaign closure event
        emit CampaignEnded(_campaignId, campaign.beneficiary, campaign.amountRaised >= campaign.goal);
    }

    // Withdraw leftover funds (only owner)
    function withdrawLeftoverFunds() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw.");
        payable(owner).transfer(balance);
    }

    // Fallback function to receive Ether
    receive() external payable {}
}