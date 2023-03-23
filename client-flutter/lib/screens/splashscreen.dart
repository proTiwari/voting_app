import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:web3dart/web3dart.dart';

import '../services/contract_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'homescreen.dart';
import 'email_screen.dart';

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
    initFunction();
    Future.delayed(Duration(seconds: 3), () {

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Get.to(EmailScreen());
          print('User is currently signed out!');
        } else {
          Get.to(CustomBottomNavigation());
          print('User is signed in!');
        }
      });
    });
  }

  double balance = 1.0;
  String walletAddress = "";
  initFunction() async {
    print("iwoeifjwoeijf");

    try {
      ContractService contractService = await ContractService.build();
      //get wallet address
      EthPrivateKey? wallet = await contractService.getOrGenerateWallet();
      walletAddress = wallet!.address.hex;
      setState(() {
        walletAddress;
      });
      AppState().address = walletAddress;
      print("iwoeifjwoeijf");

      // get balance
      EtherAmount am = await contractService.getBalance();
      print("iwoeifjwoeijf :am $am");
      balance = am.getValueInUnit(EtherUnit.ether);
      print("iwoeifjwoeijf");
      print(
          "amount: ${am}; balance: ${balance}; walletAddress: ${wallet.address.hex}");
      setState(() {
        balance;
        walletAddress;
      });
    } catch (e) {
      print("iwoeifjwoeijf");
      print("homescreen_error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child:Center(child: Image.asset("assets/voting.png"),)
      ),
    );
  }
}
