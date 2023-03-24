import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../services/code_generator.dart';
import 'package:flutter_share/flutter_share.dart';
import '../services/deeplink_service.dart';
import '../services/contract_service.dart';
import '../services/firestore_functions.dart';

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
    deeplink();
    getActiveEvents();
  }

  List activeEvents = [];

  getActiveEvents ()async{
    activeEvents = await FirestoreFunctions().getActiveEvents();
  }

  String? referLink = '';
  void deeplink() async {
    try {
      final deepLinkRepo = await DeepLinkService.instance;
      var referralCode = await deepLinkRepo?.referrerCode.value;
      print(
          "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd ${referralCode}");

      //link for joining event
      var id = "";

      final referCode =
          await CodeGenerator().generateCode('refer', id.toString());

      referLink =
          await DeepLinkService.instance?.createReferLink(referCode, "");

      setState(() {
        referLink;
      });
    } catch (e) {
      print("$e");
    }
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
      print("iwoeifjwoeijf 1");

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
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
              GestureDetector(
                onTap: () async {
                  Get.snackbar(
                      'Copied!', 'address is copied to clipboard!');
                  await Clipboard.setData(
                      ClipboardData(text: AppState().address));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  color: FlutterFlowTheme.of(context).cardBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ethereum Wallet',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .cardTextColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(Icons.copy),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              AppState().address,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .cardTextColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '$balance  ETH',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                fontFamily: 'Urbanist',
                                color: FlutterFlowTheme.of(context)
                                    .cardTextColor,
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Events',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: 'Urbanist',
                  color: FlutterFlowTheme.of(context).darkBGstatic,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex:1,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: AlignmentDirectional(-0.05, -0.8),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.91,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(220, 59, 58, 58),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${activeEvents[index].topic}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                              Text("${activeEvents[index].description}"),
                              Container()
                            ],
                          )
                        ),
                      ),
                    );
                  },
                ),
              ),


            ]),
          ),

        ),
      ),
    );
  }

  Future<void> share() async {
    print("sdfwe3");
    try {
      await FlutterShare.share(
          title: 'E-Voting App',
          text: 'completely secure blockchain voting platform',
          linkUrl: '$referLink',
          chooserTitle: '');
    } catch (e) {
      print(e);
    }
  }
}
