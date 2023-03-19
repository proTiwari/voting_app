import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class ContractService {
  late final Web3Client _web3client;
  late final EthereumAddress _contractAddress;
  late final String _abiCode;

  Future<void> getAbi() async {
    String abiFile =
        await rootBundle.loadString('assets/src/contracts/Counter.json');
    final abiJSON = jsonDecode(abiFile);
    _abiCode = jsonEncode(abiJSON['abi']);
    _contractAddress = EthereumAddress.fromHex(abiJSON['networks']['5777']['address']);
  }
}
