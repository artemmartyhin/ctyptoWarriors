pragma solidity ^0.7.4;

library SafeMath{
    function add(uint a, uint b) public pure returns(uint){
        uint c=a+b;
        assert(c>=a);
        return c;
    }
    function sub(uint a, uint b) public pure returns(uint){
        assert(b<=a);
        return a-b;
    }
}