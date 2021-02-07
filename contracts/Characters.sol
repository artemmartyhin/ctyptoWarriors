pragma solidity ^0.7.4;

import "./SafeMath.sol";

contract Characters{
    using SafeMath for uint;

    string public cname;
    string public csymbol;
    uint public ctotalSupply;
    address public cowner;

    struct Character{
        string class;

        uint physDamage;
        uint magDamage;
        uint pearceDamage;

        uint physDefence;
        uint magDefence;
        uint pearceDefence;

      
        uint skillpoints;
    }
    Character[] characters;
    mapping(uint=>address) charToOwner;
    mapping(address=>uint) charCount;
    mapping(address=>mapping(address=>uint)) c_allowed;
    constructor(){
        cname="HeroCoin";
        csymbol="HRC";
        cowner=msg.sender;
    }
    event Transfer(address from, address to, uint charId);
    event Approval(address owner, address approved, uint charId);

    function createCharacter(string memory _class) internal{
        require(charCount[msg.sender]==0);
        uint id;
        if(keccak256(bytes(_class))==keccak256("warrior")){
            characters.push(Character(_class, 3, 0, 0, 5, 1, 3, 0));
            charToOwner[id]=msg.sender;
        }
        if(keccak256(bytes(_class))==keccak256("mage")){
            characters.push(Character(_class,  0, 3, 0, 3, 5, 1, 0));   
            charToOwner[id]=msg.sender;
        }
        if(keccak256(bytes(_class))==keccak256("rogue")){
            characters.push(Character(_class,  0, 0, 3, 1, 3, 5,  0));
            charToOwner[id]=msg.sender;
        }
        id=characters.length;
        require(id!=0);
        charCount[msg.sender].add(1);
        ctotalSupply.add(1);
    }
    function buffChar(string memory _skill, uint _nump, uint _charId) internal{
        require(characters[_charId].skillpoints<=_nump);
        require(msg.sender==charToOwner[_charId]);
        if(keccak256(bytes(_skill))==keccak256("strength")){
            characters[_charId].physDamage.add(_nump+2);
            characters[_charId].pearceDefence.add(_nump+1);
            characters[_charId].physDefence.add(_nump+2);

        }
        if(keccak256(bytes(_skill))==keccak256("mana")){
            characters[_charId].magDamage.add(_nump+2);
            characters[_charId].physDefence.add(_nump+1);
            characters[_charId].magDefence.add(_nump+2);
        }
        if(keccak256(bytes(_skill))==keccak256("stamina")){
            characters[_charId].pearceDamage.add(_nump+2);
            characters[_charId].magDefence.add(_nump+1);
            characters[_charId].pearceDefence.add(_nump+2);
        }
        characters[_charId].skillpoints.sub(_nump);
    }
    function balanceOf(address _owner) virtual public view returns (uint){
        return charCount[_owner];
    }
    function ownerOf(uint _charId) virtual public view returns (address){
        return charToOwner[_charId];
    }
    function allowance(address _owner, address _delegate) virtual public view returns(uint){
        return c_allowed[_owner][_delegate];
    }
    function approve(address _to, uint _charId) virtual external{
        require(msg.sender==charToOwner[_charId]);
        c_allowed[msg.sender][_to]=_charId;
        emit Approval(msg.sender, _to, _charId);
    }
    function transfer(address _to, uint _charId) virtual external{
        charToOwner[_charId]=_to;
        charCount[msg.sender].sub(1);
        charCount[_to].add(1);
        emit Transfer(msg.sender, _to, _charId);
    }
     function transferFrom(address _from, address _to, uint _charId) virtual external{
        require(_from==charToOwner[_charId]);
        require(c_allowed[_from][_to]==_charId);
        charToOwner[_charId]=_to;
        charCount[_from].sub(1);
        charCount[_to].add(1);
        c_allowed[_from][_to]=0;
        emit Transfer(_from, _to, _charId);
    }
}