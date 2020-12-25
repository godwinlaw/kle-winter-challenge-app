import 'package:flutter/material.dart';
import 'ui/screens/login_page.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'ui/screens/home.dart';

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
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error);
          return MaterialApp(
            title: 'Klesis Winter Challenge',
            theme: ThemeData(fontFamily: 'Montserrat'),
            home: Home(),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Klesis Winter Challenge',
            home: LoginPage(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'Klesis Winter Challenge',
          home: LoadingCircle(),
        );
      },
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
