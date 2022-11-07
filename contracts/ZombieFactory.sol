// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

contract ZombieFactory {
  event NewZombie(uint256 zombieId, string name, uint256 dna);

  uint256 dnaDigits = 16;
  uint256 dnaModulus = 10**dnaDigits;

  struct Zombie {
    string name;
    uint256 dna;
  }

  Zombie[] public zombies;

  mapping(uint256 => address) public zombieToOwner;
  mapping(address => uint256) public ownerZombieCount;

  /**
   * @dev A private function that creates a zombie
   * @param _name The name of the zombie to be created
   * @param _dna The DNA of the zombie to be created
   */
  function _createZombie(string memory _name, uint256 _dna) private {
    zombies.push(Zombie(_name, _dna));
    console.log(zombies.length); // Remove that line later

    zombieToOwner[zombies.length] = msg.sender;
    ownerZombieCount[msg.sender]++;

    emit NewZombie(zombies.length, _name, _dna);
  }

  /**
   * @dev Creates a semi-random number and return it
   * @param _str A string to generate the random number from
   * @return A random number
   */
  function _generateRandomDna(string memory _str)
    private
    view
    returns (uint256)
  {
    uint256 rand = uint256(keccak256(abi.encode(_str)));

    return rand % dnaModulus;
  }

  /**
   * @dev A public function to create a zombie
   * @param _name The name of the zombie to be created
   */
  function createRandomZombie(string memory _name) public {
    require(
      ownerZombieCount[msg.sender] == 0,
      "The owner already has at least a zombie"
    );
    uint256 randDna = _generateRandomDna(_name);

    _createZombie(_name, randDna);
  }

  function getAllZombies() public view returns (Zombie[] memory) {
    return zombies;
  }
}
