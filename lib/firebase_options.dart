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
    apiKey: 'AIzaSyAcXtbGHve9sviGGHqneuKrQwx8GcKs8uA',
    appId: '1:188048224167:web:4022cd4a109e8abb065082',
    messagingSenderId: '188048224167',
    projectId: 'fir-partice-7a517',
    authDomain: 'fir-partice-7a517.firebaseapp.com',
    storageBucket: 'fir-partice-7a517.appspot.com',
    measurementId: 'G-L92BYG8M9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaRl8sLjjHw6WJlb29yy4TfJIZF8a2hsE',
    appId: '1:188048224167:android:840b2aea0b5d5410065082',
    messagingSenderId: '188048224167',
    projectId: 'fir-partice-7a517',
    storageBucket: 'fir-partice-7a517.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgVSGPpSGkZHm7A7PORpEJC5mU6wzax4U',
    appId: '1:188048224167:ios:ed408726c4a01808065082',
    messagingSenderId: '188048224167',
    projectId: 'fir-partice-7a517',
    storageBucket: 'fir-partice-7a517.appspot.com',
    iosBundleId: 'com.example.particeproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgVSGPpSGkZHm7A7PORpEJC5mU6wzax4U',
    appId: '1:188048224167:ios:861a599d2e03bb92065082',
    messagingSenderId: '188048224167',
    projectId: 'fir-partice-7a517',
    storageBucket: 'fir-partice-7a517.appspot.com',
    iosBundleId: 'com.example.particeproject.RunnerTests',
  );
}
