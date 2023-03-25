import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/objects/ElectionEvent.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import '../objects/Company.dart';
import '../objects/EmployeeSummary.dart';
import '../services/firestore_functions.dart';

class ElectionEventVoteAction extends StatefulWidget {
  final ElectionEvent event;
  const ElectionEventVoteAction(this.event, {super.key});

  @override
  State<ElectionEventVoteAction> createState() => _ElectionEventVoteActionState();
}

class _ElectionEventVoteActionState extends State<ElectionEventVoteAction> {
  bool createbox = false;
  List<EmployeeSummary> _candidates = [];
  EmployeeSummary? _selectedCandidate;
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Voting Event Details'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(widget.event.topic),
                Text(widget.event.description),
                Text(formatDate(widget.event.startTimestamp.toDate(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn])),
                Text(formatDate(widget.event.endTimestamp.toDate(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn])),
                const Text("Select Candidate to vote:"),
                // candidate options
                ..._candidates.map((element) {
                  return Material(
                      child: RadioListTile<EmployeeSummary>(
                        title: const Text('AM'),
                        subtitle: const Text('AM'),
                        groupValue: _selectedCandidate,
                        value: element,
                        onChanged:(EmployeeSummary? value) {
                          setState(() {
                            _selectedCandidate = value;
                          });
                        },
                      ),
                  );
                }).toList(),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {

              },
              child: const Text("Vote")
          ),
        ],
      ),
    );
  }

  Future<void> refresh() async {
    _candidates = await loadCandidatesData();
    setState(() {
      _candidates;
    });
  }

  Future<List<EmployeeSummary>> loadCandidatesData() async {
    return await FirestoreFunctions().getElectionEventCandidatesData(widget.event);
  }
}


