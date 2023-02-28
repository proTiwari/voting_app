const CorporateVoting = artifacts.require("CorporateVoting");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CorporateVoting", function (accounts) {
  it("should assert true", async function () {
    await CorporateVoting.deployed();
    return assert.isTrue(true);
  });

  it("getUser test", async function () {
    const instance = await CorporateVoting.deployed();
    const user = await instance.getUser.call()
    console.log(user)
    return assert.typeOf(user, 'object', 'user is object type')
  })

  it("setUser test", async function () {
    const instance = await CorporateVoting.deployed();
    await instance.setUser('shubham');
    const user = await instance.getUser.call()
    assert.typeOf(user, 'object', 'user is object type')
    expect(user.name).to.equal('shubham')
  })
});

function convertToHex(str) {
  var hex = '';
  for(var i=0;i<str.length;i++) {
    hex += ''+str.charCodeAt(i).toString(16);
  }

  return hex;
}
