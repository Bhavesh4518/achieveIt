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
    apiKey: 'AIzaSyBCVQjzbgIPl1CS1HV4B5HIvJIiE5IGA6I',
    appId: '1:533828826062:web:4cf75361458c396d01f19f',
    messagingSenderId: '533828826062',
    projectId: 'achieve-it-36478',
    authDomain: 'achieve-it-36478.firebaseapp.com',
    storageBucket: 'achieve-it-36478.appspot.com',
    measurementId: 'G-L35JXKQ6RT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAj84zzSAVzej-ByDSacvEggUAHeW6hv5k',
    appId: '1:533828826062:android:742b2c482759ae0201f19f',
    messagingSenderId: '533828826062',
    projectId: 'achieve-it-36478',
    storageBucket: 'achieve-it-36478.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDoPe2Sba-LKDlytGAbNi3lHE2fVlU9fcU',
    appId: '1:533828826062:ios:83e889e1bcd4c69801f19f',
    messagingSenderId: '533828826062',
    projectId: 'achieve-it-36478',
    storageBucket: 'achieve-it-36478.appspot.com',
    iosBundleId: 'com.example.achieveIt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDoPe2Sba-LKDlytGAbNi3lHE2fVlU9fcU',
    appId: '1:533828826062:ios:83e889e1bcd4c69801f19f',
    messagingSenderId: '533828826062',
    projectId: 'achieve-it-36478',
    storageBucket: 'achieve-it-36478.appspot.com',
    iosBundleId: 'com.example.achieveIt',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCVQjzbgIPl1CS1HV4B5HIvJIiE5IGA6I',
    appId: '1:533828826062:web:e2b08c5989d8958601f19f',
    messagingSenderId: '533828826062',
    projectId: 'achieve-it-36478',
    authDomain: 'achieve-it-36478.firebaseapp.com',
    storageBucket: 'achieve-it-36478.appspot.com',
    measurementId: 'G-CPR8NVMW1H',
  );
}
