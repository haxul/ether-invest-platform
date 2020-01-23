pragma solidity ^0.5.16;

contract SavingBook {
    using ArrayHandler for address[];
    
    uint constant DEPOSIT_TIME = 60 seconds;
    uint8 constant  INTEREST_RATE = 10;
    
    event withdrowAttempt (
        address indexed who,
        uint amount,        
        uint time
    );
    
    event withdrowSuccess (
        address indexed reciever,
        uint sum,        
        uint time
    );
    
    address payable owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    mapping(address => uint256) deposits;
    mapping(address => uint256) lastTimeInvesting;
    mapping(address => uint256) withdrowStatements;
    address[] clients;
    
    constructor() public payable {
        owner = msg.sender;
    }
    
    function transfer() public payable {
        owner.transfer(msg.value);
        setLastTimeInvesting(msg.sender);
        deposits[msg.sender] += msg.value;
        if (!clients.include(msg.sender)) clients.push(msg.sender); 
    }
    
    function createWithdrowStatement(uint amount) public payable {
       uint256 amountInDeposit = deposits[msg.sender];
       uint256 curTime = block.timestamp;
       if (amount > amountInDeposit) amount = amountInDeposit;
       require(amount > 0 && lastTimeInvesting[msg.sender] != 0);
       bool isTimePassed = (curTime - lastTimeInvesting[msg.sender]) > DEPOSIT_TIME; 
       require(isTimePassed);
       withdrowStatements[msg.sender] = amount;
       deposits[msg.sender] -= amount;
       emit withdrowAttempt(msg.sender, amount, curTime);
    }
    
    function takeBackInterest(address payable _address) public payable onlyOwner {
        uint256 interest = (withdrowStatements[_address] / 100) * (100 + INTEREST_RATE);
        require(interest != 0);
        require(owner.balance > interest);
        _address.transfer(interest);
        emit withdrowSuccess(_address, interest, now);
    }
    
    function setLastTimeInvesting(address _address) public {
        lastTimeInvesting[_address] = block.timestamp; 
    }
    
    function getLastTimeInvestingByAddress(address _address) public view returns(uint256){
        return lastTimeInvesting[_address];
    }
    
    function getInvestrerDeposit(address _address) public view returns(uint256) {
        return deposits[_address];
    }
    
    function findWithdrowStatementByAddress(address _address) public view returns(uint256) {
        return withdrowStatements[_address];
    }
    
    function findAllWithdrowStatements() public view returns(address[] memory){
        return clients;
    }
}
