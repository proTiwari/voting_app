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

  it("vote", async function () {
    const instance = await CorporateVoting.deployed();
    const tx = await instance.vote("eventid1", "sdjfkariuenjj", 1);
    console.log('transaction: ', tx);
  })

  it("get result", async function () {
    const instance = await CorporateVoting.deployed();
    const results = await instance.getResults.call("eventid1")
    console.log(results)
  })

  it('get all event votes', async function () {
    const instance = await CorporateVoting.deployed();
    // test createNewCompany
    const allEventVotes = await instance.getAllEventVotes.call("eventid1");
    console.log('allEventVotes: ', allEventVotes)
  })

  it('test all integrated', async function () {
    const eventid = 'eventid2';
    const instance = await CorporateVoting.deployed();
    for (let i = 0; i < 20; i++) {
      // get random number from 1 to 4
      const randomNumber = Math.floor(Math.random() * 4) + 1;
      const tx = await instance.vote(eventid, "sdjfkariuenjj", randomNumber);
    }
    const allEventVotes = await instance.getAllEventVotes.call(eventid);
    console.log('allEventVotes: ', allEventVotes)

    const results = await instance.getResults.call(eventid)
    console.log(results)
  })
});

function convertToHex(str) {
  var hex = '';
  for(var i=0;i<str.length;i++) {
    hex += ''+str.charCodeAt(i).toString(16);
  }

  return hex;
}
