import 'dart:math';

class CodeGenerator {
  Random random = Random();

  Future<String> generateCode(String prefix, link) async {
    return '$prefix-${link}';
  }
}
