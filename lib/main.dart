import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(WinterChallengeApp());
}

/// The entry point for bootstrapping the entire app.
class WinterChallengeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klesis Winter Challenge',
      home: LoginPage(), // On launch, prompt login
    );
  }
}
