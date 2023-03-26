import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/constants.keys.dart';
import 'package:voting_app/screens/homescreen.dart';
import 'package:voting_app/screens/email_screen.dart';
import 'package:voting_app/screens/invitation_action_screen.dart';
import 'package:voting_app/screens/splashscreen.dart';
import 'package:voting_app/services/deeplink_service.dart';
import 'services/app_state.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final appState = AppState();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DeepLinkService.instance?.handleDynamicLinks();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFFFFFFF),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
