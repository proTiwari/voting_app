import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/objects/Invite.dart';
import 'package:voting_app/screens/companies.dart';
import 'package:voting_app/screens/splashscreen.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import '../objects/Company.dart';
import '../services/firestore_functions.dart';
import 'events.dart';

class InvitationActionScreen extends StatefulWidget {
  final String inviteId;
  const InvitationActionScreen(this.inviteId, {super.key});

  @override
  State<InvitationActionScreen> createState() => _InvitationActionScreenState();
}

class _InvitationActionScreenState extends State<InvitationActionScreen> {
  bool createbox = false;
  bool _loading = false;
  String? _error = null;
  Invite? _invite = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInvitation();
  }

  getInvitation() async {
    try {
      setState(() {
        _loading = true;
      });
      _invite = await FirestoreFunctions().getInvite(widget.inviteId);
      if(_invite == null) {
        setState(() {
          _error = "Invite not found";
        });
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = "Something went wrong.";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Invitation'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Text(_error!),
                )
              : _invite == null
                  ? const Center(
                      child: Text("Invite not found"),
                    )
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "You have been invited to join ${_invite!.companyData.name}.",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "You can join the company by clicking the button below.",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      _loading = true;
                                    });
                                    await FirestoreFunctions()
                                        .acceptInvite(_invite!);
                                    setState(() {
                                      _loading = false;
                                    });
                                    Get.to(Companies());
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      _error = "Something went wrong.";
                                      _loading = false;
                                    });
                                  }
                                },
                                child: const Text("Join Company"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      _loading = true;
                                    });
                                    await FirestoreFunctions()
                                        .declineInvite(_invite!.inviteId);
                                    setState(() {
                                      _loading = false;
                                    });
                                    Get.to(Companies());
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      _error = "Something went wrong.";
                                      _loading = false;
                                    });
                                  }
                                },
                                child: const Text("Deny Invite"),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ),
    );
  }
}


