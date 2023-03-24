import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/screens/password_name.dart';
import 'package:voting_app/screens/password_screen.dart';
import 'package:voting_app/services/app_state.dart';
import '../objects/AppUser.dart';
import '../widgets/input_field.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
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
                    controller: _emailController,
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email,
                    type: TextInputType.emailAddress,
                    obscure: false,
                    label: '',
                  ),
                  // InputField(
                  //   controller: _passwordController,
                  //   hintText: 'Enter your password',
                  //   prefixIcon: Icons.lock,
                  //   type: TextInputType.text,
                  //   obscure: true,
                  //   label: '',
                  // ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          loginUser();
                        },
                        label: Text('Next'),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        ),
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

  void loginUser() async {
    final mEmail = _emailController.text.toString().trim().toLowerCase();
    try {
      var result;
      result = await AppUser.collection
          .where("email", isEqualTo: mEmail)
          .get()
          .then((value) {
        print(value.docs);
        if (value.docs.isEmpty) {
          print("user does not exist");

          if (RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(mEmail)) {
            AppState().email = mEmail;
            Get.to(Signup());
          } else {
            Get.snackbar("login error", 'email is invalid!');
          }
        }
        if (value.docs.isNotEmpty) {
          print("user does not exist");
          AppState().email = mEmail;
          Get.to(Login());
        }
      });
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }
}
