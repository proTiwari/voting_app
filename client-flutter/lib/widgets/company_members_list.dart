import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/objects/EmployeeSummary.dart';
import 'package:voting_app/screens/invite_employee.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/Company.dart';
import '../objects/ElectionEvent.dart';
import '../objects/PollEvent.dart';
import '../services/firestore_functions.dart';
import '../widgets/create_event_screen.dart';

class CompanyMembers extends StatefulWidget {
  final Company company;
  const CompanyMembers({super.key, required this.company});

  @override
  State<CompanyMembers> createState() => _CompanyMembersState();
}

class _CompanyMembersState extends State<CompanyMembers> {
  @override
  void initState() {
    super.initState();
    getAllCompanyMembers();
  }

  List<EmployeeSummary> members = [];

  getAllCompanyMembers() async {
    members = await FirestoreFunctions().getCompanyMembers(widget.company.cid);
    setState(() {
      members;
    });
    print("members: $members");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getAllCompanyMembers();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(10),
                      elevation: 0,
                      color: FlutterFlowTheme.of(context).cardBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).primaryColor,
                              size: 24,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(members[index].name,
                                        style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .cardTextColor,
                                            fontSize: 20)),
                                    SizedBox(height: 4),
                                    Text(members[index].email,
                                        style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .cardTextColor,
                                            fontSize: 12)),
                                    SizedBox(height: 8),
                                    widget.company.admin == members[index].uid
                                        ? Container(
                                      width: 70,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).cardTextColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Admin',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                            fontFamily: 'Urbanist',
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // create event
          Get.to(InviteEmployee(company: widget.company));
        },
        backgroundColor: FlutterFlowTheme.of(context).cardTextColor,
        child: Icon(
          Icons.add,
          color: FlutterFlowTheme.of(context).white,
          size: 24,
        ),
      ),
    );
  }
}
