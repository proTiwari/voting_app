import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart' as df;
import 'package:get/get.dart';
import 'package:voting_app/objects/ElectionEvent.dart';
import 'package:voting_app/objects/EmployeeSummary.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:voting_app/services/firestore_functions.dart';
import 'package:filter_list/filter_list.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../objects/Company.dart';
import '../objects/CompanySummary.dart';
import '../objects/PollEvent.dart';

class CreateEvent extends StatefulWidget {
  Map<String, EmployeeSummary> empData;
  Company companydata;
  CreateEvent({Key? key, required this.empData, required this.companydata})
      : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool _isLoading = false;
  List<String> list = <String>['Select type', 'election', 'poll'];
  String dropdownValue = 'Select type';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  double _height = Get.height;
  double _width = Get.width;

  late String _setTime, _setDate;

  late String _hour, _minute, _time;

  late String dateTime;
  late Timestamp _setstarttime;
  late Timestamp _setendtime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _starttimeController = TextEditingController();
  TextEditingController _endtimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectCandidateList = [];
    candidateList = [];
    getCandidates();
  }

  getCandidates() {
    widget.empData.entries.forEach((element) {
      print("element: ${element.value.name}");
      setState(() {
        candidateList.add(Candidate(name: element.value.name, avatar: ''));
      });
      
    });
    candidateList.forEach((element) {
      print("element: ${element.name}");
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            df.formatDate(selectedDate, [df.dd, '-', df.mm, '-', df.yyyy]);
      });
    }
  }

  Future<Null> _selectstartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    var datetime = DateTime(picked!.hour, picked.minute);
    _setstarttime = Timestamp.fromDate(datetime);
    print(datetime);
    print(picked.hour);
    print(picked.minute);
    print("ggg: ${_setstarttime}");

    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _starttimeController.text = _time;
        _starttimeController.text = df.formatDate(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, selectedTime.hour, selectedTime.minute),
            [df.hh, ':', df.nn, " ", df.am]).toString();
      });
  }

  Future<Null> _selectendTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    print(picked!.hour);
    print(picked.minute);

    var datetime = DateTime(picked!.hour, picked.minute);
    _setendtime = Timestamp.fromDate(datetime);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _endtimeController.text = _time;

        _endtimeController.text = df.formatDate(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, selectedTime.hour, selectedTime.minute),
            [df.hh, ':', df.nn, " ", df.am]).toString();
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
        return user.name!.toLowerCase().contains(query.toLowerCase());
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
                      selectCandidateList.length == 0
                          ? Container()
                          : Container(
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
                      InkWell(
                        onTap: () {
                          _selectstartTime(context);
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
                            controller: _starttimeController,
                            decoration: InputDecoration(
                                hintText: 'Select Event Start Time',
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectendTime(context);
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
                            controller: _endtimeController,
                            decoration: InputDecoration(
                                hintText: 'Select Event End Time',
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
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
                      : Text("Start Event"),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      List<String> candidate = [];
                      selectCandidateList.forEach((element) {
                        candidate.add(element.name!);
                      });
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      final docRef = Company.collection.doc();
                      ElectionEvent electionEvent = ElectionEvent(
                          evid: docRef.id,
                          topic: _nameController.text,
                          description: _descriptionController.text,
                          endTimestamp: _setendtime,
                          creationTimestamp: Timestamp.now(),
                          startTimestamp: _setstarttime,
                          cid: widget.companydata.cid,
                          voters: [],
                          candidates: candidate,
                          companyData: CompanySummary(
                            cid: widget.companydata.cid,
                            cin: widget.companydata.cin,
                            name: widget.companydata.name,
                            admin: widget.companydata.admin,
                          ));
                      await FirestoreFunctions().createElectionEvent(
                        topic: _nameController.text,
                        description: _descriptionController.text,
                        endTimestamp: _setendtime,
                        startTimestamp: _setstarttime,
                        cid: widget.companydata.cid,
                        voters: [],
                        candidates: candidate,
                      );
                      // await FirestoreFunctions().createPollEvent(poll);

                      // await FirestoreFunctions().createPollEvent(poll);
                      setState(() {
                        _isLoading = false;
                      });
                      Get.snackbar("Success", "Event Created");
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
  final String? name;
  final String? avatar;
  Candidate({this.name, this.avatar});
}
