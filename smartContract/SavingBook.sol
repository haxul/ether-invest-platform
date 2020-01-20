pragma solidity ^0.5.16;

contract SavingBook {
    
    address payable owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    mapping(address => uint256) deposits;
    mapping(address => uint256) lastTimeInvesting;
    
    constructor() public payable {
        owner = msg.sender;
    }
    
    function transfer() public payable {
        owner.transfer(msg.value);
        uint256 currrentDeposit = deposits[msg.sender]; 
        currrentDeposit == 0 ? deposits[msg.sender] = msg.value : deposits[msg.sender] += msg.value;
    }
    
    function getSmartContractBalance() view public returns(uint256) {
        return address(this).balance;
    }
    
    function getOwnerAddress() view public onlyOwner returns(address) {
        return owner;
    }
    
    function setLastTimeInvesting(address _address) public {
        lastTimeInvesting[_address] = block.timestamp; 
    }
    
    function getLastTimeInvestingByAddress(address _address) public view returns(uint256){
        return deposits[_address];
    }
}
