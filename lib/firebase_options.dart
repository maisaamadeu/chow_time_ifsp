// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAY9aAoJrUkUx2TwsEb9oH6sJptmonOCKE',
    appId: '1:423528113901:web:514257ecaf727190c20ee4',
    messagingSenderId: '423528113901',
    projectId: 'tcc-ifsp-btv',
    authDomain: 'tcc-ifsp-btv.firebaseapp.com',
    databaseURL: 'https://tcc-ifsp-btv-default-rtdb.firebaseio.com',
    storageBucket: 'tcc-ifsp-btv.appspot.com',
    measurementId: 'G-97NZDXBRN1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAblTRqWTmUiAxK3na5nkwvhxdKBW4-Oi4',
    appId: '1:423528113901:android:a97678c6eac45272c20ee4',
    messagingSenderId: '423528113901',
    projectId: 'tcc-ifsp-btv',
    databaseURL: 'https://tcc-ifsp-btv-default-rtdb.firebaseio.com',
    storageBucket: 'tcc-ifsp-btv.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBL12DMSgiXYNPZpTmvf2sHLA74C03KiKg',
    appId: '1:423528113901:ios:cb16076eca249578c20ee4',
    messagingSenderId: '423528113901',
    projectId: 'tcc-ifsp-btv',
    databaseURL: 'https://tcc-ifsp-btv-default-rtdb.firebaseio.com',
    storageBucket: 'tcc-ifsp-btv.appspot.com',
    androidClientId:
        '423528113901-9msn1ofgrk7tsga5qk05m92the13pe12.apps.googleusercontent.com',
    iosClientId:
        '423528113901-6caqg3taqlk3lokl1f7bd17e85p1dokh.apps.googleusercontent.com',
    iosBundleId: 'com.example.chowTimeIfsp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBL12DMSgiXYNPZpTmvf2sHLA74C03KiKg',
    appId: '1:423528113901:ios:b88f10dd37aa85c1c20ee4',
    messagingSenderId: '423528113901',
    projectId: 'tcc-ifsp-btv',
    databaseURL: 'https://tcc-ifsp-btv-default-rtdb.firebaseio.com',
    storageBucket: 'tcc-ifsp-btv.appspot.com',
    androidClientId:
        '423528113901-9msn1ofgrk7tsga5qk05m92the13pe12.apps.googleusercontent.com',
    iosClientId:
        '423528113901-c7utv116pgkv4ite81022eqv6q798g4u.apps.googleusercontent.com',
    iosBundleId: 'com.example.chowTimeIfsp.RunnerTests',
  );
}