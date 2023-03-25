import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/objects/Company.dart';
import 'package:voting_app/objects/EmployeeSummary.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/ElectionEvent.dart';
import '../objects/PollEvent.dart';
import '../services/firestore_functions.dart';
import '../widgets/create_event_screen.dart';
import '../widgets/events_card.dart';
import 'event_details.dart';

class CompanyEvents extends StatefulWidget {
  final Company company;
  const CompanyEvents({
    super.key,
    required this.company,
  });

  @override
  State<CompanyEvents> createState() => _CompanyEventsState();
}

class _CompanyEventsState extends State<CompanyEvents> {
  @override
  void initState() {
    super.initState();
    getAllCompanyEvents();
  }

  List<dynamic> events = [];

  getAllCompanyEvents() async {
    print(widget.company.cid!);
    events =
        await FirestoreFunctions().getAllCompanyEvents(widget.company.cid);
    setState(() {
      events;
    });
    print("events: ${events}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getAllCompanyEvents();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Column(
            children: [
              EventCard(activeEvents: events)
            ],
          ),
        ),
      ),
      floatingActionButton: widget.company.admin == FirebaseAuth.instance.currentUser!.uid ? FloatingActionButton(
        onPressed: () {
          // create event
          Get.to(CreateEvent(company: widget.company));
        },
        backgroundColor: FlutterFlowTheme.of(context).cardTextColor,
        child: Icon(
          Icons.add,
          color: FlutterFlowTheme.of(context).white,
          size: 24,
        ),
      ) : null,
    );
  }
}
