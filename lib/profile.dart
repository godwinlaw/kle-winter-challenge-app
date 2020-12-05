import 'package:flutter/material.dart';

/**
 * Screen for viewing user profile and all their commitments.
 * 
 * Owners: Christy Koh, Chloe Chan
 */
class ProfileWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileWidgetState();
  }
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: MODIFY THIS CODE.
    return Scaffold(
        appBar: AppBar(title: const Text('User Profile')),
        body: Container(color: Colors.deepOrange));
  }
}
