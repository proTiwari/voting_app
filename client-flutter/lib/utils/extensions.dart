import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

extension EthPrivateKeyUtils on EthPrivateKey {
  String get privateKeyHex => bytesToHex(privateKey, include0x: true);
  String get addressHex => address.hex;
}