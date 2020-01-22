pragma solidity ^0.6.1;

contract Contract {
    address payable public smartContract;
    
    constructor() public payable {
        smartContract = payable(address(this)); 
    }
    
    function withdraw() public {
    //   msg.sender.transfer(smartContract.balance);
       msg.sender.transfer(1 ether);
    }
    
    function getBalance() public view returns(uint256) {
        return smartContract.balance;
    }
    
    function getBalanceAnother() public view returns(uint256) {
        return address(this).balance;
    }
    
    fallback() external payable {}
}