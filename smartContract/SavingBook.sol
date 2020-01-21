pragma solidity ^0.5.16;

import "./Libraries.sol";

contract SavingBook {
    
    using AddressHandler for address;
    uint constant DEPOSIT_TIME = 60; // seconds
    
    event withdrowAttempt (
        address indexed who,
        uint amount,        
        uint time
    );
    

    address payable owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier hasMoney() {
        require(msg.sender.balance > msg.value);
        _;
    }
    
    mapping(address => uint256) deposits;
    mapping(address => uint256) lastTimeInvesting;
    mapping(address => uint256) withdrowStatements;
    
    constructor() public payable {
        owner = msg.sender;
    }
    
    function transfer() public payable hasMoney {
        owner.transfer(msg.value);
        setLastTimeInvesting(msg.sender);
        deposits[msg.sender] += msg.value;
    }
    
    function createWithdrowStatement(uint amount) public payable {
       uint256 amountInDeposit = deposits[msg.sender];
       uint256 curTime = block.timestamp;
       if (amount > amountInDeposit) amount = amountInDeposit;
       if (amount == 0 || lastTimeInvesting[msg.sender] == 0) revert("no money in deposit");
       bool isTimePassed = (curTime - lastTimeInvesting[msg.sender]) > DEPOSIT_TIME; 
       if (!isTimePassed)  revert("deposit time does not pass"); 
       withdrowStatements[msg.sender] = amount;
       deposits[msg.sender] -= amount;
       emit withdrowAttempt(msg.sender, amount, curTime);
    }
    
    function setLastTimeInvesting(address _address) public {
        lastTimeInvesting[_address] = block.timestamp; 
    }
    
    function getLastTimeInvestingByAddress(address _address) public view returns(uint256){
        return lastTimeInvesting[_address];
    }
    
    function getInvesterDeposit(address _address) public view returns(uint256) {
        return deposits[_address];
    } 
}
