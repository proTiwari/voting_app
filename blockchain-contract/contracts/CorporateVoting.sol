// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract CorporateVoting {
  constructor() public {

  }

  struct EventVote {
    address userAddress; // user wallet address
    string uid; // user id
    uint voteOptionNum; // > 0 (option number from 1)
    uint timestamp; // timestamp for vote
  }

  struct VoteTotal {
    mapping(uint => uint) totals; // mapping of option Num and total Votes
    uint[] options; // options voted
  }

  struct Result {
    uint winner;
    OptionRes[] optionTotals;
  }

  struct OptionRes {
    uint optionNum;
    uint totalVotes;
  }

  mapping(string => VoteTotal) voteTotals; // map from event id to votes totals
  mapping(string => EventVote[]) eventVotes;  // map from event id to event vote

  // get result
  function getResults(string memory evid) public view returns (Result memory) {
    Result memory res;
    // compute winner and option totals
    OptionRes[] memory optionTotals = new OptionRes[](voteTotals[evid].options.length);
    uint winner = 0;
    for(uint i = 0; i < voteTotals[evid].options.length; i++) {
      if (winner == 0) {
        winner = voteTotals[evid].options[i];
      }
      else {
        if(voteTotals[evid].totals[winner] < voteTotals[evid].totals[voteTotals[evid].options[i]]) {
          winner = voteTotals[evid].options[i];
        }
      }

      // add each option result
      optionTotals[i] = OptionRes(
        voteTotals[evid].options[i],
        voteTotals[evid].totals[voteTotals[evid].options[i]]
      );
    }
    res.winner = winner;
    res.optionTotals = optionTotals;
    return res;
  }

  // get all event votes
  function getAllEventVotes(string memory evid) public view returns (EventVote[] memory) {
    return eventVotes[evid];
  }

  // vote
  function vote(string memory evid, string memory uid, uint option) public {
    EventVote memory v;
    v.uid = uid;
    v.voteOptionNum = option;
    v.userAddress = msg.sender;
    v.timestamp = block.timestamp;
    eventVotes[evid].push(v);

    if(voteTotals[evid].totals[option] == 0) {
      voteTotals[evid].options.push(option);
    }
    voteTotals[evid].totals[option] = voteTotals[evid].totals[option] + 1;

  }
}