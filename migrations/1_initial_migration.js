const SafeMath = artifacts.require("SafeMath");
const HeroesTrader = artifacts.require("HeroesTrader");
const Characters = artifacts.require("Characters");
const CryptoWars = artifacts.require("CryptoWars");

module.exports = function (deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, [HeroesTrader, Characters, CryptoWars]);
  deployer.deploy(HeroesTrader);
  deployer.deploy(Characters);
  deployer.deploy(CryptoWars);
};
