import 'package:flutter/material.dart';

/// Screen for viewing the scoreboard.
///
/// Owners: Sarah Liu, Lily Li
class ScoreboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreboardWidgetState();
  }
}

class _ScoreboardWidgetState extends State<ScoreboardWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Scoreboard')),
      body: Container(color: Colors.yellow));
}
