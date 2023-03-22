import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:voting_app/services/firestore_functions.dart';
import '../objects/AppUser.dart';
import '../widgets/input_field.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[100],
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(top: 250),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 40.0),
                  //   child: Center(
                  //     child: Image(
                  //       image: AssetImage('assets/icons/logo.png'),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 124.0),
                  //   child: Text('AUTHENTICATION | LOG IN ',
                  //       style: TextStyle(
                  //           fontSize: 30.0,
                  //           color: Colors.indigo,
                  //           fontWeight: FontWeight.bold)),
                  // ),
                  SizedBox(
                    height: 30.0,
                  ),
                  InputField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    prefixIcon: Icons.person,
                    type: TextInputType.emailAddress,
                    obscure: false,
                    label: '',
                  ),
                  InputField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock,
                    type: TextInputType.text,
                    obscure: true,
                    label: '',
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          SignupUser(
                              AppState().email, _passwordController.text);
                        },
                        label: Text('SIGN UP'),
                        icon: Icon(Icons.verified_user),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // IconButton(
                  //   onPressed: (){
                  //     // Get.to(AuthScreen())
                  //   } ,
                  //   icon:Icon(Icons.login)
                  //   // child: Text(
                  //   //   'Dont have an account ? Sign up there',
                  //   //   style: TextStyle(color: Colors.red, fontSize: 18.0),
                  //   // ),
                  // )
                ]),
          ),
        )),
      ),
    );
  }

  void SignupUser(String email, String password) async {
    try {
      if (_nameController.text.length > 3) {
        var _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        AppUser appUser = AppUser(
            name: _nameController.text,
            email: email,
            creationTimestamp: Timestamp.now(),
            address: AppState().address,
            companies: [],
            uid: _authResult.user!.uid);
        await FirestoreFunctions().createUser(appUser);
      } else {
        Get.snackbar('Error!', 'name is too small');
      }

      // Get.back();
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }
}
