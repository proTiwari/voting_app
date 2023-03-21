import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import '../services/contract_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFunction();
  }

  double balance = 1.0;
  String walletAddress = "";
  initFunction() async {
    print("iwoeifjwoeijf");

    try {
      //get wallet address
      EthPrivateKey? wallet = await ContractService().getOrGenerateWallet();
      walletAddress = wallet!.address.hex;
      setState(() {
        walletAddress;
      });
      AppState().address = walletAddress;
      print("iwoeifjwoeijf");

      // get balance
      EtherAmount am = await ContractService().getbalance();
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
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Exit"),
                content: const Text("Are you sure you want to Exit?"),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      exit(0);
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                  ),
                ],
              );
            });
        return false;
      },
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
            child: Container(
              color: Colors.green,
              height: 200,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text("Address"), Icon(Icons.copy)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${walletAddress}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${balance} ETH"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
    );
  }
}
