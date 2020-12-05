import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(WinterChallengeApp());
}

/**
 * The entry point for bootstrapping the entire app.
 */
class WinterChallengeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klesis Winter Challenge',
      home: Home(),
    );
  }
}
