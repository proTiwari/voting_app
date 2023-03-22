import 'package:flutter/material.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../services/firestore_functions.dart';

class CompanyEvents extends StatefulWidget {
  String? cid;
  CompanyEvents({super.key, this.cid});

  @override
  State<CompanyEvents> createState() => _CompanyEventsState();
}

class _CompanyEventsState extends State<CompanyEvents> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCompanyEvents();
  }

  var events = [];

  getAllCompanyEvents() async {
    events = await FirestoreFunctions().getAllCompanyEvents(widget.cid!);
    print("iwjeofwjioe");
    print(events);
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
                'Companies',
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
                  return Align(
                    alignment: AlignmentDirectional(-0.05, -0.8),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xDC4B39EF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
