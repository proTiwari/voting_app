import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../constants.keys.dart';

class ContractService {
  late final Web3Client _web3client;
  late final EthereumAddress _contractAddress;
  late final String _abiCode;

  Future<void> getAbi() async {
    _web3client = Web3Client(Constants.RPC_URL, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(Constants.WS_URL).cast<String>();
    });
    String abiFile =
        await rootBundle.loadString('assets/src/contracts/Counter.json');
    final abiJSON = jsonDecode(abiFile);
    _abiCode = jsonEncode(abiJSON['abi']);
    _contractAddress = EthereumAddress.fromHex(abiJSON['networks']['5777']['address']);
  }
}
