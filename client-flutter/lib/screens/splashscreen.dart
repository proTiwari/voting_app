import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/screens/create_user_screen.dart';
import 'package:voting_app/screens/import_or_create_wallet_screen.dart';
import 'package:voting_app/services/firestore_functions.dart';
import 'package:web3dart/web3dart.dart';

import '../objects/AppUser.dart';
import '../services/app_state.dart';
import '../services/contract_service.dart';
import '../widgets/bottom_nav_bar.dart';

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
  }

  initFunction() async {
    try {
      //get wallet address
      EthPrivateKey? wallet = await ContractService.getWallet();
      if(wallet == null){
        Get.to(ImportOrCreateWalletScreen());
      }
      else {
        AppUser? user = await FirestoreFunctions().getUser();
        if (user == null) {
          Get.to(CreateUserScreen());
        } else {
          AppState().name = user.name;
          AppState().email = user.email;
          AppState().address = wallet.address.hex;
          Get.to(CustomBottomNavigation());
        }
      }
    } catch (e) {
      // show snack bar
      SnackBar snackBar = const SnackBar(
        content: Text("Something went wrong. Check your internet connection."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
