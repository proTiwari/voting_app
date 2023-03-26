import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/objects/BlockchainVotingResult.dart';
import 'package:voting_app/services/contract_service.dart';
import 'package:voting_app/widgets/company_members_list.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../objects/BlockchainEventVote.dart';
import '../objects/Company.dart';
import '../objects/EmployeeSummary.dart';
import '../services/firestore_functions.dart';

class ElectionEventResults extends StatefulWidget {
  final dynamic event;

  const ElectionEventResults(this.event, {super.key});

  @override
  State<ElectionEventResults> createState() => _ElectionEventResultsState();
}

class _ElectionEventResultsState extends State<ElectionEventResults> {
  bool createbox = false;
  List<EmployeeSummary> _candidates = [];
  EmployeeSummary? _selectedCandidate;
  BlockchainVotingResult? _votingResult;
  bool _pageLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.event.topic,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .cardTextColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                widget.event.description,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .cardTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                            Text(
                                'Event Starts At: ${formatDate(widget.event.startTimestamp.toDate(), [
                                      yyyy,
                                      '-',
                                      mm,
                                      '-',
                                      dd,
                                      ' ',
                                      HH,
                                      ':',
                                      nn
                                    ])}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .cardTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    )),
                            Text(
                                'Event Ends At: ${formatDate(widget.event.endTimestamp.toDate(), [
                                      yyyy,
                                      '-',
                                      mm,
                                      '-',
                                      dd,
                                      ' ',
                                      HH,
                                      ':',
                                      nn
                                    ])}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .cardTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    )),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Winners",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .cardTextColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            ..._votingResult!.winners.map((winner) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.all(10),
                                elevation: 0,
                                color: FlutterFlowTheme.of(context)
                                    .cardBackgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.recommend,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryColor,
                                        size: 24,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(winner.name,
                                                  style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .cardTextColor,
                                                      fontSize: 20)),
                                              SizedBox(height: 4),
                                              Text(winner.email,
                                                  style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .cardTextColor,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.check),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Results",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Urbanist',
                                        color: FlutterFlowTheme.of(context)
                                            .cardTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                            ),
                            // candidate options
                            ..._candidates.map((element) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: RadioListTile<EmployeeSummary>(
                                    title: Text(element.name),
                                    subtitle: Text(element.email),
                                    secondary: Text("${_votingResult!.votes.entries.where((voteResEl) => voteResEl.key.uid == element.uid).elementAt(0).value} Votes"),
                                    groupValue: _selectedCandidate,
                                    value: element,
                                    onChanged: (EmployeeSummary? value) {},
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> refresh() async {
    setState(() {
      _pageLoading = true;
    });
    _candidates = await loadCandidatesData();
    final eventVotes =
        await BlockchainEventVote.loadFromContract(widget.event.evid);
    final address = await ContractService.getAddress();
    if (address != null) {
      final userVote = eventVotes.firstWhere(
          (element) => element.uid == address,
          orElse: () => BlockchainEventVote.empty());
      if (!userVote.isEmpty()) {
        _selectedCandidate = _candidates.elementAt(userVote.optionNum - 1);
      }
    }
    _votingResult = await BlockchainVotingResult.loadFromContract(widget.event);
    print(_votingResult);
    setState(() {
      _candidates;
      _pageLoading = false;
      _votingResult;
    });
  }

  Future<List<EmployeeSummary>> loadCandidatesData() async {
    return await FirestoreFunctions()
        .getElectionEventCandidatesData(widget.event);
  }
}
