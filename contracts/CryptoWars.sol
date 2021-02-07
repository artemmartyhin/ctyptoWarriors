pragma solidity ^0.7.4;

import "./SafeMath.sol";
import "./Characters.sol";
import "./Heroestrader.sol";

contract CryptoWars is HeroesTrader{
    using SafeMath for uint;
    
    mapping(uint=>uint) fightRequests;

    event FightRequest(uint charId, uint enemyId);
    event Fight(uint caharId, uint enemyId);


    function requestFight(uint _charId, uint _enemyId) external{
        require(charToOwner[_charId]==msg.sender);
        fightRequests[_charId]=_enemyId;
        emit FightRequest(_charId, _enemyId);
    }
    function acceptFight(uint _enemyId, uint _charId) external{
        require(charToOwner[_charId]==msg.sender);
        fight(_enemyId, _charId);
    }
    function fight(uint _enemyId, uint _charId) public{
        uint eDamage;
        uint cDamage;
        if(characters[_enemyId].physDamage>characters[_charId].physDefence){
            eDamage.add(characters[_enemyId].physDamage-characters[_charId].physDefence);
        }
        if(characters[_enemyId].magDamage>characters[_charId].magDefence){
            eDamage.add(characters[_enemyId].magDamage-characters[_charId].magDefence);
        }
        if(characters[_enemyId].pearceDamage>characters[_charId].pearceDefence){
            eDamage.add(characters[_enemyId].pearceDamage-characters[_charId].pearceDefence);
        }
        if(characters[_charId].physDamage>characters[_enemyId].physDefence){
            cDamage.add(characters[_charId].physDamage-characters[_enemyId].physDefence);
        }
        if(characters[_charId].magDamage>characters[_enemyId].magDefence){
            cDamage.add(characters[_charId].magDamage-characters[_enemyId].magDefence);
        }
         if(characters[_charId].pearceDamage>characters[_enemyId].pearceDefence){
            cDamage.add(characters[_charId].pearceDamage-characters[_enemyId].pearceDefence);
        }
        if(cDamage>eDamage){
            charCount[charToOwner[_enemyId]].sub(1);
            delete(charToOwner[_enemyId]);
            characters[_charId].skillpoints.add(2);
            ownerToCash[charToOwner[_charId]].add(10);
            ownerToCash[gowner].sub(10);
        }
        if(cDamage<eDamage){
            charCount[charToOwner[_charId]].sub(1);
            delete(charToOwner[_charId]);
            characters[_enemyId].skillpoints.add(2);
            ownerToCash[charToOwner[_enemyId]].add(10);
            ownerToCash[gowner].sub(10);
        }
        if(cDamage==0){
            characters[_enemyId].skillpoints.add(1);
            characters[_charId].skillpoints.add(1);
        }
        emit Fight(_charId, _enemyId);
    }
}
