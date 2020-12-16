import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(WinterChallengeApp());
}

/// The entry point for bootstrapping the entire app.
class WinterChallengeApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return MaterialApp(title: "Error", home: ErrorState());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Klesis Winter Challenge',
              home: LoginPage(),
            );
          }

          return MaterialApp(title: "Loading", home: LoadingState());
        });
  }
}

class ErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Error")));
  }
}

class LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Loading")));
  }
}
