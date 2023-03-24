import 'dart:io';

class Constants {
  //static const String RPC_URL = "https://ethereum.publicnode.com";
  static const String RPC_URL = "https://sepolia.infura.io/v3/dde2201b7715440a85dbec0fa99afc94";
  static const String WS_URL = "wss://sepolia.infura.io/ws/v3/dde2201b7715440a85dbec0fa99afc94";
  static const String CONTRACT_ADDRESS = "0x8dCc9e5f4aBb7496fC94346b0b6C79aef17eD0EC";
  String? get token => Platform.environment['PRIVATE_KEY'];
}
