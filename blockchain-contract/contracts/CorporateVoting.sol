// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CorporateVoting {
  constructor() public {
  }

  struct Company {
    bytes32 cin;
    bytes32 name;
    address[] employees;
    address admin;
  }

  struct UserDetailsWithCompanyId {
    bool isAdmin;
    uint cid;
    bytes32 email;
  }
  
  struct User {
    bytes32 name;
    UserDetailsWithCompanyId[] companies;
  }

  mapping(address => User) users;
  Company[] companies;

  function stringToBytes32(string memory source) public pure returns (bytes32 result) {
    // require(bytes(source).length <= 32); // causes error
    // but string have to be max 32 chars
    // https://ethereum.stackexchange.com/questions/9603/understanding-mload-assembly-function
    // http://solidity.readthedocs.io/en/latest/assembly.html
    assembly {
      result := mload(add(source, 32))
    }
  }

  function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
    uint8 i = 0;
    while(i < 32 && _bytes32[i] != 0) {
      i++;
    }
    bytes memory bytesArray = new bytes(i);
    for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
      bytesArray[i] = _bytes32[i];
    }
    return string(bytesArray);
  }

  function getUser() public view returns (string memory name, address add) {
    return (bytes32ToString(users[msg.sender].name), msg.sender);
  }

  function setUser(string memory mName) public returns (string memory name, address add) {
    users[msg.sender].name = stringToBytes32(mName);
    return (mName, msg.sender);
  }

  /*function getAllEmployees(uint cid) public view returns (address[] memory employees) {
    return (companies[cid].employees);
  }*/
}
