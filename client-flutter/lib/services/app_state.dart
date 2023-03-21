import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _name = "";
  String get name => _name;
  set name(String _value) {
    _name = _value;
  }

  String _address = "";
  String get address => _address;
  set address(String _value) {
    _address = _value;
  }

  String _email = "";
  String get email => _email;
  set email(String _value) {
    _email = _value;
  }
}
