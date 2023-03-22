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
      //get wallet address
      EthPrivateKey? wallet = await ContractService().getOrGenerateWallet();
      walletAddress = wallet!.address.hex;
      setState(() {
        walletAddress;
      });
      AppState().address = walletAddress;
      print("iwoeifjwoeijf");

      // get balance
      EtherAmount am = await ContractService().getBalance();
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
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(children: [
              Align(
                alignment: AlignmentDirectional(-0.05, -0.8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.93,
                  height: 190,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(220, 59, 58, 58),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.85, -0.15),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          child: Text(
                            '${balance}  ETH',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          print("wiefw");
                          Get.snackbar(
                              'Copyed!', 'address is copyed to clipboard!');
                          await Clipboard.setData(
                              ClipboardData(text: AppState().address));
                        },
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () async {
                                  print("wiefw");
                                  Get.snackbar('Copyed!',
                                      'address is copyed to clipboard!');
                                  await Clipboard.setData(
                                      ClipboardData(text: AppState().address));
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 20, 10, 0),
                                  child: TextFormField(
                                    autofocus: true,
                                    readOnly: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText:
                                          'address:\n${AppState().address}',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                    maxLines: 3,
                                    minLines: 3,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  print("wiefw");
                                  Get.snackbar('Copyed!',
                                      'address is copyed to clipboard!');
                                  await Clipboard.setData(
                                      ClipboardData(text: AppState().address));
                                },
                                child: Align(
                                  alignment: AlignmentDirectional(0.9, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: Icon(
                                      Icons.content_copy,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: AlignmentDirectional(-0.85, 0),
                child: Text(
                  'Events',
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Urbanist',
                        color: FlutterFlowTheme.of(context).darkBGstatic,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                  height: 360,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
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
                          ),
                        ),
                      );
                    },
                  ))
            ]),
          ),
          floatingActionButton: GestureDetector(
            onTap: () async {
              print("sdfwe");
              if (referLink != '') {
                print("sdfwe1");
                await share();
              }
              print("sdfwe2");
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(1.0, 1, 41, 44),
              child: IconButton(
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color.fromARGB(220, 255, 255, 255),
                      size: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: const Icon(
                          Icons.add,
                          color: Color.fromARGB(220, 0, 0, 0),
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  print("sdfwe");
                  if (referLink != '') {
                    print("sdfwe1");
                    await share();
                  }
                  print("sdfwe2");
                },
              ),
            ),
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
