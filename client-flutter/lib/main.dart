import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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

  final data = await FirebaseDynamicLinks.instance.getInitialLink();
  final inviteId = await DeepLinkService.checkForInviteId(data);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFFFFFFF),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
      // Set up the `onLink` event listener next as it may be received here
      DeepLinkService.checkForInviteId(pendingDynamicLinkData)
          .then((inviteId)  {
            if(inviteId != null) {
              Get.to(InvitationActionScreen(inviteId));
            }
      });
    },
  );

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(inviteId: inviteId,),
  ));
}

class MyApp extends StatefulWidget {
  String? inviteId;

  MyApp({inviteId, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timerLink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(inviteId: widget.inviteId,),
    );
  }
}
