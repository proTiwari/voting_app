import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import '../objects/Company.dart';
import '../services/firestore_functions.dart';
import 'events.dart';

class EventDetails extends StatefulWidget {
  final dynamic event;
  const EventDetails(this.event, {super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
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


