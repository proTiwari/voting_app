import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/services/firestore_functions.dart';

import '../objects/Company.dart';

class CreateCompany extends StatefulWidget {
  const CreateCompany({Key? key}) : super(key: key);

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  bool _isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cinController = TextEditingController();
  TextEditingController _eidController = TextEditingController();

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
                      controller: _nameController,
                      decoration:
                          const InputDecoration(hintText: "Company Name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        controller: _cinController,
                        decoration: const InputDecoration(
                            hintText: "Company Identification No. (Optional)"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        controller: _eidController,
                        decoration: const InputDecoration(
                            hintText: "Your Employee Id"),
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
                      : Text("Add Company"),
                  onPressed: () async {
                    if(_nameController.text.isEmpty){
                      Get.snackbar("Error", "Company Name cannot be empty");
                      return;
                    }

                    if(_eidController.text.isEmpty){
                      Get.snackbar("Error", "Employee Id cannot be empty");
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });
                    try{
                      await FirestoreFunctions().createCompany(_cinController.text, _nameController.text, _eidController.text);
                      setState(() {
                        _isLoading = false;
                      });
                      Get.snackbar("Success", "Company Created");
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
