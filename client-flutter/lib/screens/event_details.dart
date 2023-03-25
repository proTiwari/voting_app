import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import 'package:voting_app/widgets/election_event_results.dart';
import 'package:voting_app/widgets/election_event_vote_action.dart';
import '../objects/Company.dart';
import '../objects/ElectionEvent.dart';
import '../objects/PollEvent.dart';
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
  EventStatus _status = EventStatus.coming;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStatus();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      initStatus();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_timer != null) {
      if(_timer!.isActive) {
        _timer!.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Voting Event Details'),
      ),
      body: _status == EventStatus.expired ? ElectionEventResults(widget.event as ElectionEvent) : ElectionEventVoteAction(widget.event as ElectionEvent, _status),
    );
  }

  initStatus() {
    if(widget.event is ElectionEvent) {
      _status = (widget.event as ElectionEvent).computeEventStatus();
    }
    else if(widget.event is PollEvent) {
      _status = (widget.event as PollEvent).computeEventStatus();
    }
    else {
      _status = EventStatus.coming;
    }
    setState(() {
      _status;
    });
  }
}


