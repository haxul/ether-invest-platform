pragma solidity ^0.5.16;

library AddressHandler {

    function makePayable(address x) internal pure returns (address payable) {
        return address(uint160(x));
    }
}