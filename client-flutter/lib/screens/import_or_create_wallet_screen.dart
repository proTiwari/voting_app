import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/flutterflow/flutter_flow_theme.dart';
import 'package:voting_app/objects/AppUser.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:voting_app/services/contract_service.dart';
import 'package:voting_app/widgets/horizontal_line_with_center_text.dart';
import 'package:web3dart/credentials.dart';

import 'package:get/get.dart';
import '../services/firestore_functions.dart';
import '../widgets/bottom_nav_bar.dart';
import 'create_user_screen.dart';

class ImportOrCreateWalletScreen extends StatefulWidget {
  String? inviteId;

  ImportOrCreateWalletScreen({inviteId, super.key});

  @override
  State<ImportOrCreateWalletScreen> createState() => _ImportOrCreateWalletScreenState();
}

class _ImportOrCreateWalletScreenState extends State<ImportOrCreateWalletScreen> {
  final TextEditingController _privateKeyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Import Wallet using Private key",
                  style: FlutterFlowTheme.of(context)
                      .bodyText1
                      .override(
                    fontFamily: 'Urbanist',
                    color: FlutterFlowTheme.of(context)
                        .cardTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: _privateKeyController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Private Key',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed:() async {
                  if (isValidPrivateKey()) {
                    await ContractService.setWallet(_privateKeyController.text);
                    AppUser? user = await FirestoreFunctions().getUser();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Wallet Imported!'),
                      ),
                    );
                    if(user == null)
                      Get.to(CreateUserScreen(inviteId: widget.inviteId,));
                    else {
                      AppState().name = user.name;
                      AppState().email = user.email;
                      Get.to(CustomBottomNavigation(inviteId: widget.inviteId));
                    }
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid Private Key'),
                      ),
                    );
                  }
                },
                child: const Text("Import Wallet"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: HorizontalOrLine(label: "OR", height: 10),
              ),
              Text(
                "Create New Wallet",
                  style: FlutterFlowTheme.of(context)
                      .bodyText1
                      .override(
                    fontFamily: 'Urbanist',
                    color: FlutterFlowTheme.of(context)
                        .cardTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed:() async {
                    try {
                      final wallet = await ContractService.getOrGenerateWallet();
                      AppState().address = wallet.address.hex;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New Wallet created!'),
                        ),
                      );
                      Get.to(CreateUserScreen(inviteId: widget.inviteId,));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unable to create new wallet! Try Again!'),
                        ),
                      );
                    }
                  },
                  child: const Text("Create New Wallet"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidPrivateKey() {
    if(_privateKeyController.text.isEmpty) return false;
    try {
      final privateKey = _privateKeyController.text;
      EthPrivateKey.fromHex(privateKey);
      return true;
    } catch (e) {
      return false;
    }
  }


}
