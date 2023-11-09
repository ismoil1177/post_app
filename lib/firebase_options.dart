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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArOUofIHOx3gWz_-aqniIEeoULFS-bCa0',
    appId: '1:725815282565:web:7020f02aab70f6432d12ec',
    messagingSenderId: '725815282565',
    projectId: 'post-2c078',
    authDomain: 'post-2c078.firebaseapp.com',
    databaseURL: 'https://post-2c078-default-rtdb.firebaseio.com',
    storageBucket: 'post-2c078.appspot.com',
    measurementId: 'G-YMKZHMY1R1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4O9mY_ryLs4Ll3xpr95UvJZzjpDd4QMc',
    appId: '1:725815282565:android:ac85d33e26c9bfff2d12ec',
    messagingSenderId: '725815282565',
    projectId: 'post-2c078',
    databaseURL: 'https://post-2c078-default-rtdb.firebaseio.com',
    storageBucket: 'post-2c078.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgJ15hP77jsUFKpu-HdTJiYVMXIIb1AMI',
    appId: '1:725815282565:ios:ef29a5c02c76ec182d12ec',
    messagingSenderId: '725815282565',
    projectId: 'post-2c078',
    databaseURL: 'https://post-2c078-default-rtdb.firebaseio.com',
    storageBucket: 'post-2c078.appspot.com',
    iosBundleId: 'com.example.postApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgJ15hP77jsUFKpu-HdTJiYVMXIIb1AMI',
    appId: '1:725815282565:ios:23c7a0d2d5f7c47a2d12ec',
    messagingSenderId: '725815282565',
    projectId: 'post-2c078',
    databaseURL: 'https://post-2c078-default-rtdb.firebaseio.com',
    storageBucket: 'post-2c078.appspot.com',
    iosBundleId: 'com.example.postApp.RunnerTests',
  );
}
