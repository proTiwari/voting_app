import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/objects/EmployeeSummary.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/Company.dart';
import '../objects/CompanySummary.dart';
import '../screens/events.dart';

class CompanyCard extends StatelessWidget {
  final Company _companySummary;
  const CompanyCard(this._companySummary, {super.key});

  @override
  Widget build(BuildContext context) {
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
              Icons.business,
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
                    _companySummary.cin.isNotEmpty
                        ? Text(_companySummary.cin,
                            style: TextStyle(
                                color:
                                    FlutterFlowTheme.of(context).cardTextColor,
                                fontSize: 12))
                        : Container(),
                    const SizedBox(height: 4),
                    Text(_companySummary.name,
                        style: TextStyle(
                            color: FlutterFlowTheme.of(context).cardTextColor,
                            fontSize: 20)),
                    const SizedBox(height: 6),
                    _companySummary.admin ==
                            FirebaseAuth.instance.currentUser!.uid
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
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
