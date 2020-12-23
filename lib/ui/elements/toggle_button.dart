import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart" as auth;

class ToggleButton extends StatefulWidget {
  final user = auth.FirebaseAuth.instance.currentUser;
  Future<bool> isCompleted;
  void markComplete;
  ToggleButton(Future<bool> _isCompleted, void _markComplete) {
    this.isCompleted = _isCompleted;
    this.markComplete = _markComplete;
  }
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ToggleButtons(
        borderColor: Colors.black,
        fillColor: Colors.white,
        borderWidth: 1,
        selectedBorderColor: Color.fromRGBO(234, 197, 103, 1),
        selectedColor: Colors.black,
        borderRadius: BorderRadius.circular(12),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
            child: Text(
              'Not Yet',
              style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
            child: Text(
              'I did it!',
              style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
            ),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        },
        isSelected: isSelected,
      ),
    );
  }
}
