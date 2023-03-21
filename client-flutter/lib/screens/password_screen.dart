import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/screens/homescreen.dart';
import '../services/app_state.dart';
import '../widgets/input_field.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // InputField(
                //   controller: _emailController,
                //   hintText: 'Enter your email',
                //   prefixIcon: Icons.email,
                //   type: TextInputType.emailAddress,
                //   obscure: false,
                //   label: '',
                // ),
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
                        loginUser(AppState().email, _passwordController.text);
                      },
                      label: Text('SIGN IN'),
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
    );
  }

  void loginUser(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      Get.to(HomeScreen());
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }
}
