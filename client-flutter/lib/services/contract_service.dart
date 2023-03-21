import 'dart:convert';
import 'dart:math'; //used for the random number generator
import 'package:flutter/material.dart';
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

  Future<void> getAbi() async {
    _web3client = Web3Client(Constants.RPC_URL, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(Constants.WS_URL).cast<String>();
    });
    String abiFile = await rootBundle.loadString('assets/Counter.json');
    final abiJSON = jsonDecode(abiFile);
    _abiCode = jsonEncode(abiJSON['abi']);
    _contractAddress =
        EthereumAddress.fromHex(abiJSON['networks']['5777']['address']);
  }

  getbalance() async {
    EthPrivateKey? wallet = await getOrGenerateWallet();
    return Web3Client(Constants.RPC_URL, Client()).getBalance(wallet!.address);
  }

  EthPrivateKey _generateWallet() {
    var rng = Random.secure();
    EthPrivateKey random = EthPrivateKey.createRandom(rng);
    return random;
  }

  Future<EthPrivateKey?> getOrGenerateWallet() async {
    print("wijefowijeoifjwoiefwo");
    try {
      var prefs = await SharedPreferences.getInstance();
      print("wijefowijeoifjwoiefwo 2");
      dynamic privateKey = prefs.getString('privatekey');
      print("privatekey: ${privateKey}");

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
}



/*
1. generate wallet which has private key, public key, and address. Save private key securely.
2. On Home page, have a card for eth balance and public key
*/
