import 'dart:io';

class Constants {
  static const String RPC_URL = "http://127.0.0.1:7545";
  static const String WS_URL = "ws://127.0.0.1:7545";
  String? get token => Platform.environment['PRIVATE_KEY'];
}
