import 'dart:convert';
import 'dart:math'; //used for the random number generator
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../constants.keys.dart';
import 'package:web3dart/crypto.dart';

class ContractService {
  late final Web3Client _web3client;
  late final EthereumAddress _contractAddress;
  late final String _abiCode;

  final String RPC_URL = 'https://sepolia.infura.io/v3/${dotenv.env['INFURA_SEPOLIA_API_KEY']!}';
  final String WS_URL = "wss://sepolia.infura.io/ws/v3/${dotenv.env['INFURA_SEPOLIA_API_KEY']!}";

  ContractService._();

  Future<void> getAbi() async {
    _web3client = Web3Client(RPC_URL, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(WS_URL).cast<String>();
    });
    String abiFile = await rootBundle.loadString('assets/CorporateVoting.json');
    final abiJSON = jsonDecode(abiFile);
    _abiCode = jsonEncode(abiJSON['abi']);
    _contractAddress = EthereumAddress.fromHex(abiJSON['networks']['11155111']['address']);
  }

  static getBalance() async {
    EthPrivateKey? wallet = await getWallet();
    return Web3Client(Constants.RPC_URL, Client()).getBalance(wallet!.address);
  }

  static EthPrivateKey _generateWallet() {
    var rng = Random.secure();
    EthPrivateKey random = EthPrivateKey.createRandom(rng);
    return random;
  }

  // get wallet from shared preferences
  static Future<EthPrivateKey?> getWallet() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      dynamic privateKey = prefs.getString('privatekey');

      print("contract_service: ${privateKey.toString()}");

      if (privateKey == null) {
        return null;
      } else {
        EthPrivateKey wallet = _getCredentialsFromPrivateKey(privateKey);
        return wallet;
      }
    } catch (e) {
      print("contract_service: ${e.toString()}");
      return null;
    }
  }

  static Future<EthPrivateKey> getOrGenerateWallet() async {
      var prefs = await SharedPreferences.getInstance();
      dynamic privateKey = prefs.getString('privatekey');

      if (privateKey == null) {
        EthPrivateKey wallet = _generateWallet();
        String s = bytesToHex(wallet.privateKey);
        prefs.setString("privatekey", s);
        AppState().address = wallet.address.hex;
        return wallet;
      } else {
        EthPrivateKey wallet = _getCredentialsFromPrivateKey(privateKey);
        return wallet;
      }
  }

  static Future<EthPrivateKey> setWallet(String privateKey) async {
    var prefs = await SharedPreferences.getInstance();
    EthPrivateKey wallet = _getCredentialsFromPrivateKey(privateKey);
    String s = bytesToHex(wallet.privateKey);
    prefs.setString("privatekey", s);
    AppState().address = wallet.address.hex;
    return wallet;
  }

  static EthPrivateKey _getCredentialsFromPrivateKey(String privateKey) {
    return EthPrivateKey.fromHex(privateKey);
  }

  static Future<String?> getAddress() async {
    EthPrivateKey? wallet = await getWallet();
    return wallet?.address.hex;
  }

  // vote in contract
  Future<String> vote(String eventId, String uid, int optionNum) async {
    EthPrivateKey? wallet = await getWallet();
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "CorporateVoting"), _contractAddress);
    final vote = contract.function("vote");
    final result = await _web3client.sendTransaction(
        wallet!,
        Transaction.callContract(
            contract: contract,
            function: vote,
            parameters: [eventId, uid, BigInt.from(optionNum)]),
            chainId: 11155111);
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
