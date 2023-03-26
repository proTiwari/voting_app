import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:voting_app/services/contract_service.dart';
import 'package:voting_app/utils/extensions.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../services/contract_service.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  EthPrivateKey? _ethPrivateKey;
  String? _privateKeyString;
  bool _loading = false;

  initState() {
    super.initState();
    _getPrivateKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Expanded(
                child: _loading ? const Center(child: CircularProgressIndicator()) : _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              tileColor: FlutterFlowTheme.of(context).cardBackgroundColor,
              title: Text(AppState().name),
              subtitle: Text(AppState().email),
              leading: const Icon(Icons.person),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListTile(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _ethPrivateKey!.addressHex));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Copied Address to Clipboard'),
                  duration: Duration(seconds: 2),
                ));
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              tileColor: FlutterFlowTheme.of(context).cardBackgroundColor,
              title: const Text('Wallet Address'),
              subtitle: Text(_ethPrivateKey!.addressHex),
              isThreeLine: true,
              trailing: const Icon(Icons.copy),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              tileColor: FlutterFlowTheme.of(context).cardBackgroundColor,
              title: const Text('Private Key'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showPrivateKeyDialog();
              },
            ),
          ),

        ],
      );

  showPrivateKeyDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Private Key'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Never share your private key with anyone!', style: FlutterFlowTheme.of(context)
                    .bodyText2
                    .override(
                  fontFamily: 'Urbanist',
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(_ethPrivateKey!.privateKeyHex, style: FlutterFlowTheme.of(context)
                      .bodyText2
                      .override(
                    fontFamily: 'Urbanist',
                    color: FlutterFlowTheme.of(context)
                        .cardTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Copy Private Key'),
              onPressed: () {
                // Copy private key to clipboard
                Clipboard.setData(ClipboardData(text: _ethPrivateKey!.privateKeyHex));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Copied to Clipboard'),
                  duration: Duration(seconds: 2),
                ));
                Get.back();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () async {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  _getPrivateKey () async {
    setState(() {
      _loading = true;
    });
    _ethPrivateKey = await ContractService.getWallet();
    setState(() {
      _ethPrivateKey;
      _loading = false;
    });
  }

  _getSanitizedPrivateKey(EthPrivateKey? key) {
    if(key == null) return '';
    final h = bytesToHex(key.privateKey);
    // remove leading zeroes from h

  }

 
}
