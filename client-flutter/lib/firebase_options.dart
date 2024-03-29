// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDji01ocOiCPoZoX1_VQzH0jv7YTvicn4',
    appId: '1:657952523892:android:4a2c830ac03dbe667ff321',
    messagingSenderId: '657952523892',
    projectId: 'corporate-voting-system',
    storageBucket: 'corporate-voting-system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPASYHILwoRWbUJjzHjOqdXQmnpEYota8',
    appId: '1:657952523892:ios:0ebe2a6b5769a52b7ff321',
    messagingSenderId: '657952523892',
    projectId: 'corporate-voting-system',
    storageBucket: 'corporate-voting-system.appspot.com',
    androidClientId: '657952523892-77ncgn1433jhsu24m92q5qdm8tmqin41.apps.googleusercontent.com',
    iosClientId: '657952523892-rknce492kpp5edj7u3panmo0gr5l72q2.apps.googleusercontent.com',
    iosBundleId: 'com.example.votingApp',
  );
}
