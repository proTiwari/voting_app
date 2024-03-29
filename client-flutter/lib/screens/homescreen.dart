import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:voting_app/globals.dart';
import 'package:voting_app/screens/invitation_action_screen.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../services/code_generator.dart';
import 'package:flutter_share/flutter_share.dart';
import '../services/deeplink_service.dart';
import '../services/contract_service.dart';
import '../services/firestore_functions.dart';
import '../widgets/events_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFunction();
    refresh();
  }

  List activeEvents = [];

  getActiveEvents() async {
    activeEvents = await FirestoreFunctions().getActiveEvents();
    setState(() {
      activeEvents;
    });
  }

  Future<void> refresh() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await getActiveEvents();
      await initFunction();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong. Try Again.'),
        duration: Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double balance = 1.0;
  String walletAddress = "";
  initFunction() async {
      //get wallet address
      String? address = await ContractService.getAddress();
      walletAddress = address!;
      setState(() {
        walletAddress;
      });

      // get balance
      EtherAmount am = await ContractService.getBalance();
      balance = am.getValueInUnit(EtherUnit.ether);
      setState(() {
        balance;
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text("Exit"),
        //         content: const Text("Are you sure you want to Exit?"),
        //         actions: [
        //           IconButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             icon: const Icon(
        //               Icons.cancel,
        //               color: Colors.red,
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: () async {
        //               exit(0);
        //             },
        //             icon: const Icon(
        //               Icons.done,
        //               color: Colors.green,
        //             ),
        //           ),
        //         ],
        //       );
        //     });
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () {
              return refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: !_isLoading ? () async {
                        Get.snackbar(
                            'Copied!', 'address is copied to clipboard!');
                        await Clipboard.setData(
                            ClipboardData(text: AppState().address));
                      }: null,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        color: FlutterFlowTheme.of(context).cardBackgroundColor,
                        child: _isLoading ? const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(child: CircularProgressIndicator()),
                        ) : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                    SizedBox(height: 20),
                    Text(
                      'Active Events',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Urbanist',
                            color: FlutterFlowTheme.of(context).darkBGstatic,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    //event card
                    EventCard(
                      activeEvents: activeEvents,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
