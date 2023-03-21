import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/constants.keys.dart';
import 'package:voting_app/screens/homescreen.dart';
import 'package:voting_app/screens/email_screen.dart';
import 'package:voting_app/screens/splashscreen.dart';
import 'package:voting_app/services/deeplink_service.dart';
import 'services/app_state.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  final appState = AppState();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DeepLinkService.instance?.handleDynamicLinks();
  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
