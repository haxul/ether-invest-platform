pragma solidity ^0.5.16;

library AddressHandler {
    function makePayable(address x) internal pure returns (address payable) {
        return address(uint160(x));
    }
}

library ArrayHandler {
   function include(address[] memory list, address _address) internal pure returns(bool) {
       for (uint i = 0; i < list.length; i++) {
           if (list[i] == _address) return true;
       }
       return false;
   }
}