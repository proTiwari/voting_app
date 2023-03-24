import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/objects/Company.dart';
import 'package:voting_app/objects/EmployeeSummary.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/ElectionEvent.dart';
import '../objects/PollEvent.dart';
import '../services/firestore_functions.dart';
import '../widgets/create_event_screen.dart';

class CompanyEvents extends StatefulWidget {
  Company companydata;
  CompanyEvents({
    super.key,
    required this.companydata, required String cid,
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
    events =
        await FirestoreFunctions().getAllCompanyEvents(widget.companydata.cid!);
    print("events: ${events}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
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
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  var type = events[index].runtimeType;
                  String topic = "";
                  String description = "";
                  String timeStr = "";
                  if (type == ElectionEvent) {
                    final event = events[index] as ElectionEvent;
                    topic = event.topic;
                    description = event.description;
                  } else if (type == PollEvent) {
                    final event = events[index] as PollEvent;
                    topic = event.topic;
                    description = event.description;
                  }
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
                                  Text('${topic}',
                                      style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .cardTextColor,
                                          fontSize: 20)),
                                  SizedBox(height: 4),
                                  Text('${description}',
                                      style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .cardTextColor,
                                          fontSize: 12)),
                                  SizedBox(height: 6),
                                  Text('${timeStr}',
                                      style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .cardTextColor,
                                          fontSize: 8)),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {},
                          )
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // create event
          print("jnkjnknk");
          Get.to(CreateEvent(empData: widget.companydata.empData, companydata: widget.companydata));
         
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
