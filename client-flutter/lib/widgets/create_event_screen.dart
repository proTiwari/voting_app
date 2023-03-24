import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart' as df;
import 'package:get/get.dart';
import 'package:voting_app/services/firestore_functions.dart';
import 'package:filter_list/filter_list.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../objects/Company.dart';

class CreateEvent extends StatefulWidget {
  Company company;
  CreateEvent({Key? key, required this.company})
      : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool _isLoading = false;
  List<String> list = <String>['Select type', 'election', 'poll'];
  String dropdownValue = 'Select type';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final double _height = Get.height;
  final double _width = Get.width;

  DateTimeRange? _selectedDateRange;
  TimeOfDay? _selectedStartTimeOfDay;
  TimeOfDay? _selectedEndTimeOfDay;

  String? _startDateText = null;
  String? _endDateText = null;
  String? _startTimeText = null;
  String? _endTimeText = null;

  @override
  void initState() {
    super.initState();
    selectCandidateList = [];
    candidateList = [];
    getCandidates();
  }

  getCandidates() {
    widget.company.empData.values.forEach((element) {
      print("element: ${element.name}");
      setState(() {
        candidateList.add(Candidate(uid: element.uid, name: element.name, avatar: ''));
      });
    });
  }

  Future<void> _selectstartTime(BuildContext context) async {
    _selectedStartTimeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedStartTimeOfDay ?? const TimeOfDay(hour: 00, minute: 00),
    );

    if(_selectedStartTimeOfDay != null && _selectedDateRange != null) {
      _startTimeText = df.formatDate(
          DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month,
              _selectedDateRange!.end.day, _selectedStartTimeOfDay!.hour, _selectedStartTimeOfDay!.minute),
          [df.hh, ':', df.nn, " ", df.am]).toString();
    }

    setState(() {
      _selectedStartTimeOfDay;
      _startTimeText;
    });
  }

  Future<void> _selectendTime(BuildContext context) async {
    _selectedEndTimeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedEndTimeOfDay ?? const TimeOfDay(hour: 00, minute: 00),
    );

    if(_selectedEndTimeOfDay != null && _selectedDateRange != null) {
      _endTimeText = df.formatDate(
          DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month,
              _selectedDateRange!.end.day, _selectedEndTimeOfDay!.hour, _selectedEndTimeOfDay!.minute),
          [df.hh, ':', df.nn, " ", df.am]).toString();
    }

    setState(() {
      _selectedEndTimeOfDay = _selectedEndTimeOfDay;
      _endTimeText;
    });
  }

  // select date range
  Future<void> _selectDateRange(BuildContext context) async {
    _selectedDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025)
    );

    if(_selectedDateRange != null) {
      _startDateText =
          df.formatDate(_selectedDateRange!.start, [df.dd, '-', df.mm, '-', df.yyyy]);
      _endDateText =
          df.formatDate(_selectedDateRange!.end, [df.dd, '-', df.mm, '-', df.yyyy]);
    }
    setState(() {
      _selectedDateRange = _selectedDateRange;
      _startDateText;
      _endDateText;
    });
  }

  List<Candidate> selectCandidateList = [];

  Future<void> openCandidateDialog() async {
    await FilterListDialog.display<Candidate>(
      width: MediaQuery.of(context).size.width < 800
          ? 14
          : MediaQuery.of(context).size.width * 0.28,
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Select candidate',
      height: 500,
      listData: candidateList,
      selectedListData: selectCandidateList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.Reset],
      onItemSearch: (user, query) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectCandidateList = List.from(list!);
        });
        Navigator.pop(context);
      },
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
            color: isSelected!
                ? FlutterFlowTheme.of(context).alternate
                : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected
                    ? FlutterFlowTheme.of(context).alternate
                    : Colors.grey[500]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Spacer(),
              SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        decoration:
                            const InputDecoration(hintText: "Event Topic"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Event Description"),
                        ),
                      ),

                      // DropdownButton<String>(
                      //   isExpanded: true,
                      //   hint: const Text('Select type'),
                      //   icon: const Icon(Icons.arrow_downward),
                      //   elevation: 16,
                      //   value: dropdownValue,
                      //   style: const TextStyle(color: Colors.deepPurple),
                      //   underline: Container(
                      //     height: 2,
                      //     color: Colors.deepPurpleAccent,
                      //   ),
                      //   onChanged: (String? value) {
                      //     // This is called when the user selects an item.
                      //     setState(() {
                      //       dropdownValue = value!;
                      //     });
                      //   },
                      //   items: list.map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),

                      // code for candidate
                      InkWell(
                        onTap: () {
                          openCandidateDialog();
                        },
                        child: Container(
                          width: _width / 1.1,
                          height: _height / 13,
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'Select Candidates',
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                      selectCandidateList.isEmpty
                          ? Container()
                          : SizedBox(
                              height: 150,
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          childAspectRatio: 4 / 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          maxCrossAxisExtent: 160),
                                  itemCount: selectCandidateList.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 235, 234, 231),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                            "${selectCandidateList[index].name}"),
                                      ),
                                    );
                                  }),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(onPressed: () {
                          _selectDateRange(context);
                        }, child: const Text("Select Date Range")),
                      ),
                      _selectedDateRange != null ? InkWell(
                        onTap: () {
                          _selectstartTime(context);
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Text(_startDateText ?? "Select Date Range", style: TextStyle(fontSize: 16, color: FlutterFlowTheme.of(context).cardTextColor, fontWeight: FontWeight.w600),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                width: 2,
                                height: 35,
                                color: FlutterFlowTheme.of(context).cardTextColor,
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_startTimeText ?? "Select Start Time", style: TextStyle(fontSize: 16, color: FlutterFlowTheme.of(context).cardTextColor, fontWeight: FontWeight.w600),),
                                    Icon(Icons.arrow_drop_down, color: FlutterFlowTheme.of(context).cardTextColor, size: 30,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : Container(),
                      const SizedBox(height: 20),
                      _selectedDateRange != null ? InkWell(
                        onTap: () {
                          _selectendTime(context);
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8),),
                          child: Row(
                            children: [
                              Text(_endDateText ?? "Select Date Range", style: TextStyle(fontSize: 16, color: FlutterFlowTheme.of(context).cardTextColor, fontWeight: FontWeight.w600),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                width: 2,
                                height: 35,
                                color: FlutterFlowTheme.of(context).cardTextColor,
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_endTimeText ?? "Select End Time", style: TextStyle(fontSize: 16, color: FlutterFlowTheme.of(context).cardTextColor, fontWeight: FontWeight.w600),),
                                    Icon(Icons.arrow_drop_down, color: FlutterFlowTheme.of(context).cardTextColor, size: 30,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Start Event"),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {

                      await FirestoreFunctions().createElectionEvent(
                        topic: _nameController.text,
                        description: _descriptionController.text,
                        endTimestamp: Timestamp.fromDate(DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, _selectedEndTimeOfDay!.hour, _selectedEndTimeOfDay!.minute)),
                        startTimestamp: Timestamp.fromDate(DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day, _selectedStartTimeOfDay!.hour, _selectedStartTimeOfDay!.minute)),
                        cid: widget.company.cid,
                        voters: [],
                        candidates: selectCandidateList.map((e) => e.uid).toList(),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                      print('create_event: success');
                      Get.back();
                    } catch (e) {
                      print(e.toString());
                      setState(() {
                        _isLoading = false;
                      });
                      Get.snackbar("Error", e.toString());
                    }
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

List<Candidate> candidateList = [];

class Candidate {
  final String uid;
  final String name;
  final String? avatar;
  Candidate({required this.uid, required this.name, this.avatar});
}
