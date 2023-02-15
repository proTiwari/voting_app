const CorporateVoting = artifacts.require("CorporateVoting");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CorporateVoting", function (/* accounts */) {
  it("should assert true", async function () {
    await CorporateVoting.deployed();
    return assert.isTrue(true);
  });
});
