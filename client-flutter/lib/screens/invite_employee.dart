import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/services/firestore_functions.dart';

import '../objects/Company.dart';


class InviteEmployee extends StatefulWidget {
  final Company company;
  const InviteEmployee({Key? key, required this.company}) : super(key: key);

  @override
  State<InviteEmployee> createState() => _InviteEmployeeState();
}

class _InviteEmployeeState extends State<InviteEmployee> {
  bool _isLoading = false;
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Company"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Spacer(),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _companyEmailController,
                      decoration:
                      const InputDecoration(hintText: "Employee's Company Email"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        controller: _employeeIdController,
                        decoration: const InputDecoration(
                            hintText: "Employee ID"),
                      ),
                    ),
                  ],
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
                      : Text("Send Invite"),
                  onPressed: () async {
                    if(_companyEmailController.text.trim().isEmpty || _employeeIdController.text.trim().isEmpty){
                      Get.snackbar("Error", "Please fill all the fields");
                      return;
                    }
                    else if(!_companyEmailController.text.trim().toLowerCase().isEmail){
                      Get.snackbar("Error", "Give correct email address");
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });
                    try{
                      await FirestoreFunctions().inviteUser(_companyEmailController.text.trim().toLowerCase(), widget.company.cid, _employeeIdController.text.trim());
                      setState(() {
                        _isLoading = false;
                      });
                      Get.snackbar("Success", "Invitation Sent!");
                      Navigator.pop(context);
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
