import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/screens/invitation_action_screen.dart';
import 'package:voting_app/services/app_state.dart';
import 'package:voting_app/services/firestore_functions.dart';
import 'package:voting_app/widgets/bottom_nav_bar.dart';
import '../flutterflow/flutter_flow_theme.dart';
import '../objects/AppUser.dart';
import '../widgets/input_field.dart';

class CreateUserScreen extends StatefulWidget {
  String? inviteId;

  CreateUserScreen({inviteId, super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                      "Provide your details please.",
                      style: FlutterFlowTheme.of(context)
                          .bodyText1
                          .override(
                        fontFamily: 'Urbanist',
                        color: FlutterFlowTheme.of(context)
                            .cardTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      )
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your email',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(onPressed: !_isSaving ? () async {
                    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
                      const snackBar = SnackBar(content: Text('Please enter your name and email'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    try {
                      setState(() {
                        _isSaving = true;
                      });
                      final user = await createUser();
                      AppState().name = user.name;
                      AppState().email = user.email;
                      Get.to(CustomBottomNavigation(inviteId: widget.inviteId,));

                    } catch (e) {
                      const snackBar = SnackBar(content: Text('Something went wrong! Please check connection and try again.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                      setState(() {
                        _isSaving = false;
                      });
                    }
                  }: null,
                      child: Text(_isSaving ? 'Saving...':'Save')
                  ),
                ),
              ]),
        )),
      ),
    );
  }

  Future<AppUser> createUser() async {
    return await FirestoreFunctions().createUser(name: _nameController.text, email: _emailController.text);
  }
}
