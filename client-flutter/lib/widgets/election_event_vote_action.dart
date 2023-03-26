import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/objects/BlockchainEventVote.dart';
import 'package:voting_app/objects/ElectionEvent.dart';
import 'package:voting_app/services/contract_service.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../objects/EmployeeSummary.dart';
import '../objects/PollEvent.dart';
import '../services/firestore_functions.dart';

class ElectionEventVoteAction extends StatefulWidget {
  final ElectionEvent event;
  final EventStatus status;
  const ElectionEventVoteAction(this.event, this.status, {super.key});

  @override
  State<ElectionEventVoteAction> createState() => _ElectionEventVoteActionState();
}

class _ElectionEventVoteActionState extends State<ElectionEventVoteAction> {
  bool createbox = false;
  List<EmployeeSummary> _candidates = [];
  EmployeeSummary? _selectedCandidate;
  bool _hasVoted = false;
  bool _isVotingInProgress = false;
  bool _pageLoading = true;
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageLoading ? const Center(child: CircularProgressIndicator()) :
      RefreshIndicator(
        onRefresh: () { return refresh(); },
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
                      widget.status == EventStatus.active ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).greenColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Active',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                fontFamily: 'Urbanist',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                          : Container(),

                      Text(widget.event.topic, style: FlutterFlowTheme.of(context)
                          .bodyText1
                          .override(
                        fontFamily: 'Urbanist',
                        color: FlutterFlowTheme.of(context)
                            .cardTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(widget.event.description, style: FlutterFlowTheme.of(context)
                            .bodyText2
                            .override(
                          fontFamily: 'Urbanist',
                          color: FlutterFlowTheme.of(context)
                              .cardTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),),
                      ),
                      Text('Event Starts At: ${formatDate(widget.event.startTimestamp.toDate(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn])}',
                          style: FlutterFlowTheme.of(context)
                              .bodyText2
                              .override(
                            fontFamily: 'Urbanist',
                            color: FlutterFlowTheme.of(context)
                                .cardTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )
                      ),
                      Text('Event Ends At: ${formatDate(widget.event.endTimestamp.toDate(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn])}',
                          style: FlutterFlowTheme.of(context)
                              .bodyText2
                              .override(
                            fontFamily: 'Urbanist',
                            color: FlutterFlowTheme.of(context)
                                .cardTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text( _hasVoted ? "You have voted:" : "Select Candidate to vote:", style: FlutterFlowTheme.of(context)
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                              child: RadioListTile<EmployeeSummary>(
                                title: Text(element.name),
                                subtitle: Text(element.email),
                                groupValue: _selectedCandidate,
                                value: element,
                                onChanged:(EmployeeSummary? value) {
                                  setState(() {
                                    _selectedCandidate = value;
                                  });
                                },
                              ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            _hasVoted ? Container() : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: widget.status == EventStatus.active && !_isVotingInProgress ? () {
                  onVotePressed();
                } : null,
                child: _isVotingInProgress ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(width: 10),
                    Text("Voting..."),
                  ],
                ) : const Text("Vote")
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
    _hasVoted = false;
    _candidates = await loadCandidatesData();
    final eventVotes = await BlockchainEventVote.loadFromContract(widget.event.evid);
    final address = await ContractService.getAddress();
    if(address != null) {
      final userVote = eventVotes.firstWhere((element) => element.uid == address, orElse: () => BlockchainEventVote.empty());
      if(!userVote.isEmpty()) {
        _selectedCandidate = _candidates.elementAt(userVote.optionNum - 1);
        _hasVoted = true;
      }
    }
    setState(() {
      _candidates;
      _pageLoading = false;
      _hasVoted;
    });
  }

  Future<List<EmployeeSummary>> loadCandidatesData() async {
    return await FirestoreFunctions().getElectionEventCandidatesData(widget.event);
  }

  void onVotePressed() {
    // get event status and check if it is active
    // check if user has voted
    // if all checks pass, then vote

    final currStatus = widget.event.computeEventStatus();
    if(currStatus != EventStatus.active) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event is not active"),
        ),
      );
      return;
    }

    if(_selectedCandidate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a candidate"),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm to vote'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are going to vote for: ${_selectedCandidate!.name} (${_selectedCandidate!.email}})'),
                const Text('Would you like to confirm this vote?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                Get.back();
                vote();
              },
            ),
          ],
        );
      },
    );

  }

  Future<void> vote() async {
    try {
      setState(() {
        _isVotingInProgress = true;
      });
      ContractService contractService = await ContractService.build();
      final address = await ContractService.getAddress();
      String transactionHash = await contractService.vote(widget.event.evid, address!, _candidates.indexOf(_selectedCandidate!) + 1);
      print('transactionHash: $transactionHash');
      await ElectionEvent.collection.doc(widget.event.evid).update({
        'transactionHash': transactionHash,
      });
      setState(() {
        _hasVoted = true;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Check if you have enough ETH to pay for gas."),
        ),
      );
    } finally {
      setState(() {
        _isVotingInProgress = false;
      });
    }

  }
}


