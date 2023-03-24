import 'package:flutter/material.dart';
import '../services/firestore_functions.dart';
import 'events.dart';

class CompanyDetails extends StatefulWidget {
  final String cid;
  const CompanyDetails(this.cid, {super.key});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  bool createbox = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventsList();
  }

  List<dynamic> events = [];

  getEventsList() async {
    events = await FirestoreFunctions().getAllCompanyEvents(widget.cid);
    setState(() {
      events;
    });

    print("events are: $events");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Company Details'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Events',
              ),
              Tab(
                text: 'Members',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CompanyEvents(cid: widget.cid),
            Center(
              child: Text("It's rainy here"),
            ),
          ],
        ),
      ),
    );
  }
}


