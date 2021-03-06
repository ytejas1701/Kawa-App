// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// / Default [FirebaseOptions] for use with your Firebase apps.
// /
// / Example:
// / ```dart
// / import 'firebase_options.dart';
// / // ...
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
// / ```
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
    apiKey: 'AIzaSyCP7bGlg30mM7To4zs8MPeVIuzrEMx9FGc',
    appId: '1:86845811964:web:f4ce063e213fa17bf7bb79',
    messagingSenderId: '86845811964',
    projectId: 'kawa-app-7fcfa',
    authDomain: 'kawa-app-7fcfa.firebaseapp.com',
    storageBucket: 'kawa-app-7fcfa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhvp--PXjq6N1CgaaS2A7M5btDQQGnT1w',
    appId: '1:86845811964:android:d70da6b06efac7ebf7bb79',
    messagingSenderId: '86845811964',
    projectId: 'kawa-app-7fcfa',
    storageBucket: 'kawa-app-7fcfa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkj6EauuNyNBoXVhTIQ_GaYehLq7jQBWA',
    appId: '1:86845811964:ios:3c42b2414d2d2cfef7bb79',
    messagingSenderId: '86845811964',
    projectId: 'kawa-app-7fcfa',
    storageBucket: 'kawa-app-7fcfa.appspot.com',
    iosClientId:
        '86845811964-aq68mn2tsauopq2j635id52abo14vmll.apps.googleusercontent.com',
    iosBundleId: 'com.example.kawaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkj6EauuNyNBoXVhTIQ_GaYehLq7jQBWA',
    appId: '1:86845811964:ios:3c42b2414d2d2cfef7bb79',
    messagingSenderId: '86845811964',
    projectId: 'kawa-app-7fcfa',
    storageBucket: 'kawa-app-7fcfa.appspot.com',
    iosClientId:
        '86845811964-aq68mn2tsauopq2j635id52abo14vmll.apps.googleusercontent.com',
    iosBundleId: 'com.example.kawaApp',
  );
}
