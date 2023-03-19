const CorporateVoting = artifacts.require("CorporateVoting");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CorporateVoting", async function (accounts) {
  it("should assert true", async function () {
    await CorporateVoting.deployed();
    return assert.isTrue(true);
  });

  it("get user", async function () {
    const instance = await CorporateVoting.deployed();
    const user = await instance.getUser.call()
    console.log(user)
    return assert.typeOf(user, 'object', 'user is object type')
  })

  it("set user with name shubham", async function () {
    const instance = await CorporateVoting.deployed();
    await instance.setUser('shubham');
    const user = await instance.getUser.call()
    assert.typeOf(user, 'object', 'user is object type')
    expect(user.name).to.equal('shubham')
  })

  it('create new company and get all companies of user; then match it', async function () {
    const instance = await CorporateVoting.deployed();
    // test createNewCompany
    await instance.createNewCompany('c1', 'adminc1@email.com');

    // test getAllCompaniesAssociatedWithUser
    const companies = await instance.getAllCompaniesAssociatedWithUser.call()
    console.log(companies)
    expect(companies).to.have.lengthOf(1)
    expect(companies[0]).to.have.property('email');
    expect(companies[0]).to.have.property('isAdmin');
    expect(companies[0]).to.have.property('cid');
    expect(companies[0]).to.have.property('company');
    expect(companies[0].email).to.equal('adminc1@email.com')
    expect(companies[0].isAdmin).to.equal(true)
    expect(companies[0].company.name).to.equal('c1')

    // https://rfr.com/verify-add-employee?cid=1&email=skdhfkj@fs.com

    // test addEmployeeInCompany
    await instance.addEmployeeInCompany(companies[0].cid, 'emp1c1@email.com');

    // test getCompany
    const company = await instance.getCompany.call(companies[0].cid)
    console.log('company', company)
    expect(company).to.have.property('name');
    expect(company).to.have.property('admin');
    expect(company).to.have.property('cin');
    expect(company).to.have.property('employees').with.lengthOf(2);
    expect(company.cin).to.equal(companies[0].company.cin)
    expect(company.admin).to.equal(companies[0].company.admin)
    expect(company.name).to.equal(companies[0].company.name)

    // test getAllEmployees
    const employees = await instance.getAllEmployees.call(companies[0].cid)
    console.log('all employees', employees)
    expect(employees).to.have.lengthOf(2)
    expect(employees[0]).to.have.property('name');
    expect(employees[0]).to.have.property('email');
    expect(employees[0]).to.have.property('cid');
    expect(employees[0]).to.have.property('isAdmin');

  })
});

function convertToHex(str) {
  var hex = '';
  for(var i=0;i<str.length;i++) {
    hex += ''+str.charCodeAt(i).toString(16);
  }

  return hex;
}
