import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import '../objects/Company.dart';
import '../services/firestore_functions.dart';
import 'events.dart';

class CompanyDetails extends StatefulWidget {
  final Company company;
  const CompanyDetails(this.company, {super.key});

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
    events = await FirestoreFunctions().getAllCompanyEvents(widget.company.cid);
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
            CompanyEvents(cid: widget.company.cid, companydata: widget.company,),
            CompanyMembers(company: widget.company),
          ],
        ),
      ),
    );
  }
}


