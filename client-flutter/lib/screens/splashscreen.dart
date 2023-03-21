import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/screens/namescreen.dart';

import 'homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Get.to(NameScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
