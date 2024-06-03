// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDGAMx67LZZ7gueeiTOIdAHHNPvFOT17bI',
    appId: '1:155720681304:web:17efac7427b50808cd872d',
    messagingSenderId: '155720681304',
    projectId: 'flutter-calc-app',
    authDomain: 'flutter-calc-app.firebaseapp.com',
    storageBucket: 'flutter-calc-app.appspot.com',
    measurementId: 'G-60YDLQV772',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiJqbc7AuyevM2t7-Vdq29y8vbcwSYMkI',
    appId: '1:155720681304:android:2e33819a4574c516cd872d',
    messagingSenderId: '155720681304',
    projectId: 'flutter-calc-app',
    storageBucket: 'flutter-calc-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHT5Uqzy24KXsMl2hIL3g1Ed_Opxeuhxk',
    appId: '1:155720681304:ios:8734166468c4261ccd872d',
    messagingSenderId: '155720681304',
    projectId: 'flutter-calc-app',
    storageBucket: 'flutter-calc-app.appspot.com',
    iosBundleId: 'com.example.flutterCalculator',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHT5Uqzy24KXsMl2hIL3g1Ed_Opxeuhxk',
    appId: '1:155720681304:ios:8734166468c4261ccd872d',
    messagingSenderId: '155720681304',
    projectId: 'flutter-calc-app',
    storageBucket: 'flutter-calc-app.appspot.com',
    iosBundleId: 'com.example.flutterCalculator',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDGAMx67LZZ7gueeiTOIdAHHNPvFOT17bI',
    appId: '1:155720681304:web:f53f0887c560eab4cd872d',
    messagingSenderId: '155720681304',
    projectId: 'flutter-calc-app',
    authDomain: 'flutter-calc-app.firebaseapp.com',
    storageBucket: 'flutter-calc-app.appspot.com',
    measurementId: 'G-DK5260M8LV',
  );

}