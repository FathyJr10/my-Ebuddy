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
    apiKey: 'AIzaSyAv-2cLmb6ZJmhAQo_1uUjZtPi90NBRuxc',
    appId: '1:334875306446:web:9bbb331d965ef565c7a39f',
    messagingSenderId: '334875306446',
    projectId: 'my-e-buddy',
    authDomain: 'my-e-buddy.firebaseapp.com',
    storageBucket: 'my-e-buddy.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYzmPcvUdnSpxPvkWYF0LDGkD9J15HM3M',
    appId: '1:334875306446:android:73f1c06c6d724ebbc7a39f',
    messagingSenderId: '334875306446',
    projectId: 'my-e-buddy',
    storageBucket: 'my-e-buddy.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAR70j78atyJ2Mjh6r8lGbHYQofnV593E8',
    appId: '1:334875306446:ios:dd793962158c78d8c7a39f',
    messagingSenderId: '334875306446',
    projectId: 'my-e-buddy',
    storageBucket: 'my-e-buddy.firebasestorage.app',
    iosBundleId: 'com.example.myEBuddy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAR70j78atyJ2Mjh6r8lGbHYQofnV593E8',
    appId: '1:334875306446:ios:dd793962158c78d8c7a39f',
    messagingSenderId: '334875306446',
    projectId: 'my-e-buddy',
    storageBucket: 'my-e-buddy.firebasestorage.app',
    iosBundleId: 'com.example.myEBuddy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAv-2cLmb6ZJmhAQo_1uUjZtPi90NBRuxc',
    appId: '1:334875306446:web:4b93d79396a4465ec7a39f',
    messagingSenderId: '334875306446',
    projectId: 'my-e-buddy',
    authDomain: 'my-e-buddy.firebaseapp.com',
    storageBucket: 'my-e-buddy.firebasestorage.app',
  );
}
