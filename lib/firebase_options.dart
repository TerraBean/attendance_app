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
    apiKey: 'AIzaSyBfy_kQPFyjIWKVIeJHjlGATisMkfeEQlQ',
    appId: '1:389001289211:web:746437dff42803d38ebf5e',
    messagingSenderId: '389001289211',
    projectId: 'teleport-6841c',
    authDomain: 'teleport-6841c.firebaseapp.com',
    databaseURL: 'https://teleport-6841c.firebaseio.com',
    storageBucket: 'teleport-6841c.appspot.com',
    measurementId: 'G-HHH5H4SFLG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBO5WsZBhuXK72r5DnZSMDu7lbd01USv2M',
    appId: '1:389001289211:android:ad362b79b1ad19208ebf5e',
    messagingSenderId: '389001289211',
    projectId: 'teleport-6841c',
    databaseURL: 'https://teleport-6841c.firebaseio.com',
    storageBucket: 'teleport-6841c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuKX9zsWjyQGiK_BLyO-3yti_GE4FbKVU',
    appId: '1:389001289211:ios:77f92231a9d17f758ebf5e',
    messagingSenderId: '389001289211',
    projectId: 'teleport-6841c',
    databaseURL: 'https://teleport-6841c.firebaseio.com',
    storageBucket: 'teleport-6841c.appspot.com',
    androidClientId: '389001289211-63e4khuc56q82rma348v2hf4t5qg2qqs.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendanceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuKX9zsWjyQGiK_BLyO-3yti_GE4FbKVU',
    appId: '1:389001289211:ios:77f92231a9d17f758ebf5e',
    messagingSenderId: '389001289211',
    projectId: 'teleport-6841c',
    databaseURL: 'https://teleport-6841c.firebaseio.com',
    storageBucket: 'teleport-6841c.appspot.com',
    androidClientId: '389001289211-63e4khuc56q82rma348v2hf4t5qg2qqs.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendanceApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBfy_kQPFyjIWKVIeJHjlGATisMkfeEQlQ',
    appId: '1:389001289211:web:4c750239659ddd938ebf5e',
    messagingSenderId: '389001289211',
    projectId: 'teleport-6841c',
    authDomain: 'teleport-6841c.firebaseapp.com',
    databaseURL: 'https://teleport-6841c.firebaseio.com',
    storageBucket: 'teleport-6841c.appspot.com',
    measurementId: 'G-JNFZ0SHZNP',
  );
}