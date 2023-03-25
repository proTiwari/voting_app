import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CodeGenerator {
  Random random = Random();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> generateCode(String prefix, link) async {
    return '$prefix-${link}';
  }
}
