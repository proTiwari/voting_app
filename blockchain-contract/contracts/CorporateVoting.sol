// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CorporateVoting {
  constructor() public {
  }

  struct Company {
    string cin;
    string name;
    address[] employees;
    address admin;
  }

  struct UserDetailsWithCompanyId {
    bool isAdmin;
    uint cid;
    string email;
  }

  struct User {
    string name;
    UserDetailsWithCompanyId[] companies;
    mapping(uint => UserDetailsWithCompanyId) mappingOfCidToCompaniesDetails;
  }

  mapping(address => User) users;
  Company[] companies;

  struct UserCompanyState {
    string name;
    string email;
    bool isAdmin;
    uint cid;
  }

  struct CompanyState {
    string email;
    bool isAdmin;
    uint cid;
    Company company;
  }

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
    return (users[msg.sender].name, msg.sender);
  }

  function setUser(string memory mName) public returns (string memory name, address add) {
    users[msg.sender].name = mName;
    return (mName, msg.sender);
  }

  function getAllEmployees(uint cid) public view returns (UserCompanyState[] memory) {
    address[] memory employeeAdd = companies[cid].employees;
    UserCompanyState[] memory employees = new UserCompanyState[](employeeAdd.length);

    for (uint i = 0; i < employeeAdd.length; i++) {
      users[employeeAdd[i]].mappingOfCidToCompaniesDetails[cid].email;
      employees[i] = UserCompanyState(
        users[employeeAdd[i]].name,
        users[employeeAdd[i]].mappingOfCidToCompaniesDetails[cid].email,
        users[employeeAdd[i]].mappingOfCidToCompaniesDetails[cid].isAdmin,
        cid
      );
    }
    return employees;
  }

  function getCompany(uint cid) public view returns (Company memory) {
    return companies[cid];
  }

  function getAllCompaniesAssociatedWithUser() public view returns (CompanyState[] memory) {
    User storage u = users[msg.sender];
    CompanyState[] memory mCompanies = new CompanyState[](u.companies.length);

    for (uint i = 0; i < u.companies.length; i++) {
      Company memory c = companies[u.companies[i].cid];
      mCompanies[i] = CompanyState(
        u.companies[i].email,
        u.companies[i].isAdmin,
        u.companies[i].cid,
        c
      );
    }
    return mCompanies;
  }

  // create new company with cin
  function createNewCompany(string memory cname, string memory email, string memory cin) public {
    Company memory c;
    c.cin = cin;
    c.name = cname;
    c.admin = msg.sender;
    companies.push(c);
    companies[companies.length - 1].employees.push(msg.sender);
    UserDetailsWithCompanyId memory userDetails = UserDetailsWithCompanyId(true, companies.length - 1, email);
    users[msg.sender].companies.push(userDetails);
    users[msg.sender].mappingOfCidToCompaniesDetails[companies.length - 1] = userDetails;
  }

  // create new company without cin
  function createNewCompany(string memory cname, string memory email) public {
    createNewCompany(cname, email, "");
  }

  // this function will be call when user will verify from the email
  function addEmployeeInCompany(uint cid, string memory eemail) public {
    companies[cid].employees.push(msg.sender);
    UserDetailsWithCompanyId memory userDetails = UserDetailsWithCompanyId(false, cid, eemail);
    users[msg.sender].companies.push(userDetails);
    users[msg.sender].mappingOfCidToCompaniesDetails[cid] = userDetails;
  }
}
