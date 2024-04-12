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
    apiKey: 'AIzaSyC_YLq6kId3HbcAAveEs9fn-rYtNt68Hh0',
    appId: '1:1000709436967:web:b3f3defb55b36e359a8002',
    messagingSenderId: '1000709436967',
    projectId: 'newsappcollege',
    authDomain: 'newsappcollege.firebaseapp.com',
    storageBucket: 'newsappcollege.appspot.com',
    measurementId: 'G-8LNYGGGSP6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIWL7d4gBM4czkAzYIRrIjCWqarNpHmaI',
    appId: '1:1000709436967:android:61040eb666c9e7269a8002',
    messagingSenderId: '1000709436967',
    projectId: 'newsappcollege',
    storageBucket: 'newsappcollege.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBO9InGtx7CWiJlWBIY9VeYrcEt2suqEnE',
    appId: '1:1000709436967:ios:ab632c884e712b739a8002',
    messagingSenderId: '1000709436967',
    projectId: 'newsappcollege',
    storageBucket: 'newsappcollege.appspot.com',
    iosBundleId: 'com.example.newsapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBO9InGtx7CWiJlWBIY9VeYrcEt2suqEnE',
    appId: '1:1000709436967:ios:ab632c884e712b739a8002',
    messagingSenderId: '1000709436967',
    projectId: 'newsappcollege',
    storageBucket: 'newsappcollege.appspot.com',
    iosBundleId: 'com.example.newsapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_YLq6kId3HbcAAveEs9fn-rYtNt68Hh0',
    appId: '1:1000709436967:web:69fd7eed6872639f9a8002',
    messagingSenderId: '1000709436967',
    projectId: 'newsappcollege',
    authDomain: 'newsappcollege.firebaseapp.com',
    storageBucket: 'newsappcollege.appspot.com',
    measurementId: 'G-X82Q7101GW',
  );

}