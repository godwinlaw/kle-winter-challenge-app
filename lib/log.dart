import 'package:flutter/material.dart';

/// Screen for user to log completed commitments.
///
/// Owners: Matthew Yu, Michael Jiang
class LogWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogWidgetState();
  }
}

class _LogWidgetState extends State<LogWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Log Commitments')),
      body: Container(color: Colors.green));
}
