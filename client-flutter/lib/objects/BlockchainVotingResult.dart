// create a class named BlockchainVotingResult with properties:
// - winners: List<String>
// - votes: Map<EmployeeSummary, int>
// Path: lib\objects\BlockchainVotingResult.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/objects/ElectionEvent.dart';
import 'package:voting_app/services/firestore_functions.dart';

import '../services/contract_service.dart';
import 'EmployeeSummary.dart';

class BlockchainVotingResult {
  final List<EmployeeSummary> winners;
  final Map<EmployeeSummary, int> votes;

  BlockchainVotingResult({
    required this.winners,
    required this.votes,
  });

  static Future<BlockchainVotingResult> loadFromContract(ElectionEvent event) async {
    Map<EmployeeSummary, int> votes = {};
    ContractService contractService = await ContractService.build();
    final bRes = await contractService.getVoteResults(event.evid);
    final candidatesList = await FirestoreFunctions().getElectionEventCandidatesData(event);
    final results = bRes[0] as List<dynamic>;
    final winner = results[0] as BigInt;
    final resVotes = results[1] as List<dynamic>;
    int maxVotes = 0;
    for (var v in (resVotes)) {
      print("vote: $v");
      BigInt optionNum = v[0];
      BigInt noOfVotes = v[1];
      maxVotes = maxVotes < noOfVotes.toInt() ? noOfVotes.toInt() : maxVotes;
      votes[candidatesList[optionNum.toInt() - 1]] = noOfVotes.toInt();
      candidatesList.removeAt(optionNum.toInt() - 1);
    }
    for (var c in candidatesList) {
      votes[c] = 0;
    }

    return BlockchainVotingResult(
      winners: votes.entries.where((element) => element.value == maxVotes).map((e) => e.key).toList(),
      votes: votes,
    );
  }
}