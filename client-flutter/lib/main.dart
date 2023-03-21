import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/constants.keys.dart';
import 'package:voting_app/screens/splashscreen.dart';
import 'services/app_state.dart';

void main() {
  final appState = AppState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
