import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import '../objects/Company.dart';
import '../services/firestore_functions.dart';

class ElectionEventResults extends StatefulWidget {
  final dynamic event;
  const ElectionEventResults(this.event, {super.key});

  @override
  State<ElectionEventResults> createState() => _ElectionEventResultsState();
}

class _ElectionEventResultsState extends State<ElectionEventResults> {
  bool createbox = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Voting Event Details'),
      ),
      body: Column(
        children: <Widget>[
        ],
      ),
    );
  }
}


