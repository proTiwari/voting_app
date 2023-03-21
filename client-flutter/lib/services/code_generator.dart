import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CodeGenerator {
  Random random = Random();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> generateCode(String prefix, property) async {
    return '$prefix-${property}';
  }

  Future<String> generateCodeformoneyreward(String prefix) async {
    var id = await auth.currentUser!.uid.toString();

    return '$prefix-${id.toString()}';
  }
}
