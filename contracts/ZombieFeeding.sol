// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.8.0 <0.9.0;

import "./ZombieFactory.sol";

interface KittyInterface {
  function getKitty(uint256 _id)
    external
    view
    returns (
      bool isGestating,
      bool isReady,
      uint256 cooldownIndex,
      uint256 nextActionAt,
      uint256 siringWithId,
      uint256 birthTime,
      uint256 matronId,
      uint256 sireId,
      uint256 generation,
      uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {
    require(
      msg.sender == zombieToOwner[_zombieId],
      "You must own the zombie to feed it"
    );

    Zombie storage myZombie = zombies[_zombieId];

    _targetDna = _targetDna % dnaModulus;

    uint256 newDna = (_targetDna + myZombie.dna) / 2;

    _createZombie("NoName", newDna);
  }
}
