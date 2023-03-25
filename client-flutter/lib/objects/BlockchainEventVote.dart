// create a class BlockchainEventVote with properties:
// - String address
// - Timestamp timestamp
// - String uid
// - int optionNum
//Path: lib\objects\BlockchainEventVote.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web3dart/credentials.dart';

import '../services/contract_service.dart';

class BlockchainEventVote {
  final String address;
  final Timestamp timestamp;
  final String uid;
  final int optionNum;

  BlockchainEventVote({
    required this.address,
    required this.timestamp,
    required this.uid,
    required this.optionNum,
  });

  static Future<List<BlockchainEventVote>> loadFromContract(String eventId) async {
    List<BlockchainEventVote> mEVotes = [];
    ContractService contractService = await ContractService.build();
    final eventVotes = await contractService.getAllEventVotes(eventId);
    for (var e in (eventVotes[0] as List<dynamic>)) {
      print("eventVote: $e");
      print("eventVotes types: ${e[0].runtimeType}; ${e[1].runtimeType}; ${e[2].runtimeType}; ${e[3].runtimeType}");
      EthereumAddress address = e[0] as EthereumAddress;
      String uid = e[1] as String;
      BigInt optionNum = e[2] as BigInt;
      Timestamp timestamp = Timestamp.fromMicrosecondsSinceEpoch((e[3] as BigInt).toInt());
      mEVotes.add(BlockchainEventVote(
        address: address.hex,
        timestamp: timestamp,
        uid: uid,
        optionNum: optionNum.toInt(),
      ));
    }
    return mEVotes;
  }

  isEmpty() {
    return address == '';
  }

  static empty() {
    return BlockchainEventVote(
      address: '',
      timestamp: Timestamp.now(),
      uid: '',
      optionNum: 0,
    );
  }
}