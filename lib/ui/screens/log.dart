import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:winterchallenge/core/data/database.dart';
import '../elements/toggle_button.dart';
import "./../../core/data/database.dart";
import "package:firebase_auth/firebase_auth.dart" as auth;

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

  final user = auth.FirebaseAuth.instance.currentUser;

  List<bool> isSelectedVerse;
  List<bool> isSelectedServanthood;
  bool verse;
  bool servanthood;
  void initState() {
    FirebaseRepository()
        .isVerseMemorizedForCurrentWeek(user.uid)
        .then((value) => isSelectedVerse = [value, !value]);
    FirebaseRepository()
        .isServanthoodCompletedForCurrentWeek(user.uid)
        .then((value) => isSelectedServanthood = [value, !value]);

    super.initState();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            'Track your progress',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light),
      body: SingleChildScrollView(
          child: Center(
              child: Container(
        width: 350.0,
        color: Colors.white,
        child: Column(children: [
          SizedBox(height: 50),
          Center(
            child: Text(
              'Week 1',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'If my people who are called by my name humble themselves, and pray and seek my face and turn from their wicked ways, then I will hear from heaven and will forgive their sin and heal their land',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              '2 Chronicles 7:14',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Memory Verses',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: ToggleButtons(
              borderColor: Colors.black,
              fillColor: Colors.white,
              borderWidth: 1,
              selectedBorderColor: Color.fromRGBO(234, 197, 103, 1),
              selectedColor: Colors.black,
              borderRadius: BorderRadius.circular(12),
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
                  child: Text(
                    'Not Yet',
                    style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
                  child: Text(
                    'I did it!',
                    style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
                  ),
                ),
              ],
              onPressed: (int index) {
                FirebaseRepository().markVerseMemorized(user.uid);
                setState(() {
                  for (int i = 0; i < isSelectedVerse.length; i++) {
                    isSelectedVerse[i] = i == index;
                  }
                });
              },
              isSelected: isSelectedVerse,
            ),
          ), // toggle button
          SizedBox(height: 100),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Servanthood',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              'Did you clean the toilets 1x a week?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: ToggleButtons(
              borderColor: Colors.black,
              fillColor: Colors.white,
              borderWidth: 1,
              selectedBorderColor: Color.fromRGBO(234, 197, 103, 1),
              selectedColor: Colors.black,
              borderRadius: BorderRadius.circular(12),
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
                  child: Text(
                    'Not Yet',
                    style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
                  child: Text(
                    'I did it!',
                    style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
                  ),
                ),
              ],
              onPressed: (int index) {
                FirebaseRepository()
                    .markServanthoodCommitmentCompleted(user.uid);
                setState(() {
                  for (int i = 0; i < isSelectedServanthood.length; i++) {
                    isSelectedServanthood[i] = i == index;
                  }
                });
              },
              isSelected: isSelectedServanthood,
            ),
          ),
          SizedBox(height: 100),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Prayer',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  'Toby Chen',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  'Michael Jiang',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  'Merryle Wang',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ]),
      ))));
}
