import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';

void main() {
  runApp(WinterChallengeApp());
}

/// The entry point for bootstrapping the entire app.
class WinterChallengeApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return "Error";
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Klesis Winter Challenge',
            home: Home(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return "Loading";
      },
    );
  }
}
