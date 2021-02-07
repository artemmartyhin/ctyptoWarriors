pragma solidity ^0.7.4;

import "./SafeMath.sol";
import "./Characters.sol";

contract HeroesTrader is Characters{
    using SafeMath for uint;
    string public gname;
    string public gsymbol;
    uint public gtotalSupply;
    address public gowner;

    constructor(){
        gname="HeroesGold";
        gsymbol="HRG";
        gtotalSupply=1000000000;
        ownerToCash[msg.sender].add(gtotalSupply);
        gowner=msg.sender;
    }

    mapping(address=>uint) ownerToCash;
    mapping(address=>mapping(address=>uint)) allowed;
    mapping(uint=>uint) sellRequests;

    event SellRequest(address indexed owner, uint charId, uint amount);
    event Buy(address indexed owner, address indexed buyer, uint charId);

    function totalSupply() public view returns (uint){
        return gtotalSupply;
    }
    function balanceOf(address _owner) override public view returns(uint){
        return ownerToCash[_owner];
    }
    function allowance(address _owner, address _delegate) override public view returns(uint){
        return allowed[_owner][_delegate];
    }
    function transfer(address _to, uint _amount) override external{
        require(ownerToCash[msg.sender]<=_amount);
        ownerToCash[msg.sender].sub(_amount);
        ownerToCash[_to].add(_amount);
        emit Transfer(msg.sender, _to, _amount);
    }
    function approve(address _to, uint _amount) override external{
        require(ownerToCash[msg.sender]<=_amount);
        allowed[msg.sender][_to]=_amount;
        emit Approval(msg.sender, _to, _amount);
    }
    function transferFrom(address _from, address _to, uint _amount) override external{
        require(ownerToCash[_from]<=_amount);
        require(allowed[_from][_to]==_amount);
        allowed[_from][_to].sub(_amount);
        ownerToCash[_from].sub(_amount);
        ownerToCash[_to].add(_amount);
        emit Transfer(_from, _to, _amount);
    }
    function requestSell(uint _charId, uint _amount) external{
        require(_amount!=0);
        require(charToOwner[_charId]==msg.sender);
        sellRequests[_charId]=_amount;
        SellRequest(msg.sender, _charId, _amount);
    }
    function buyHero(uint _charId) external{
        require(ownerToCash[msg.sender]>=sellRequests[_charId]);
        require(sellRequests[_charId]!=0);
        address owner=charToOwner[_charId];
        ownerToCash[charToOwner[_charId]].add(sellRequests[_charId]);
        ownerToCash[msg.sender].sub(sellRequests[_charId]);
        charToOwner[_charId]=msg.sender;
        sellRequests[_charId]=0;
        Buy(owner, msg.sender, _charId);
    }
}