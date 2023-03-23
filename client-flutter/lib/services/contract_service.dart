import 'dart:convert';
import 'dart:math'; //used for the random number generator
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../constants.keys.dart';
import 'package:web3dart/crypto.dart';

class ContractService {
  late final Web3Client _web3client;
  late final EthereumAddress _contractAddress;
  late final String _abiCode;

  ContractService._();

  Future<void> getAbi() async {
    _web3client = Web3Client(Constants.RPC_URL, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(Constants.WS_URL).cast<String>();
    });
    String abiFile = await rootBundle.loadString('assets/CorporateVoting.json');
    final abiJSON = jsonDecode(abiFile);
    _abiCode = jsonEncode(abiJSON['abi']);
    _contractAddress = EthereumAddress.fromHex(abiJSON['networks']['11155111']['address']);
  }

  getBalance() async {
    EthPrivateKey? wallet = await getOrGenerateWallet();
    return Web3Client(Constants.RPC_URL, Client()).getBalance(wallet!.address);
  }

  EthPrivateKey _generateWallet() {
    var rng = Random.secure();
    EthPrivateKey random = EthPrivateKey.createRandom(rng);
    return random;
  }

  Future<EthPrivateKey?> getOrGenerateWallet() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      dynamic privateKey = prefs.getString('privatekey');

      if (privateKey == null) {
        EthPrivateKey wallet = _generateWallet();
        String s = bytesToHex(wallet.privateKey);
        prefs.setString("privatekey", s);
        return wallet;
      } else {
        EthPrivateKey wallet = _getCredentialsFromPrivateKey(privateKey);
        return wallet;
      }
    } catch (e) {
      print("contract_service: ${e.toString()}");
      return null;
    }
  }

  EthPrivateKey _getCredentialsFromPrivateKey(String privateKey) {
    return EthPrivateKey.fromHex(privateKey);
  }

  Future<String> getAddress() async {
    EthPrivateKey? wallet = await getOrGenerateWallet();
    return wallet!.address.hex;
  }

  // vote in contract
  Future<String> vote(String eventId, String uid, String optionNum) async {
    EthPrivateKey? wallet = await getOrGenerateWallet();
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CorporateVoting"), _contractAddress);
    final vote = contract.function("vote");
    final result = await _web3client.sendTransaction(
        wallet!,
        Transaction.callContract(
            contract: contract, function: vote, parameters: [eventId, uid, optionNum]),
        fetchChainIdFromNetworkId: true);
    return result;
  }

  // call method getAllEventVotes from contract given eventId
  Future<List<dynamic>> getAllEventVotes(String eventId) async {
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CorporateVoting"), _contractAddress);
    final getAllEventVotes = contract.function("getAllEventVotes");
    final result = await _web3client.call(
        contract: contract,
        function: getAllEventVotes,
        params: [eventId]);
    return result;
  }

  // call method getResults from contract from given eventId
  Future<List<dynamic>> getVoteResults(String eventId) async {
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CorporateVoting"), _contractAddress);
    final getResults = contract.function("getResults");
    final result = await _web3client.call(
        contract: contract, function: getResults, params: [eventId]);
    return result;
  }

  static Future<ContractService> build() async {
    ContractService contractService = ContractService._();
    await contractService.getAbi();
    return contractService;
  }
}



/*
1. generate wallet which has private key, public key, and address. Save private key securely.
2. On Home page, have a card for eth balance and public key
*/
