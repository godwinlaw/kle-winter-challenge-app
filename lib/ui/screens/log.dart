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
  List<bool> isPrayerCompleted;
  bool verse;
  bool servanthood;
  void initState() {
    FirebaseRepository()
        .isVerseMemorizedForCurrentWeek(user.uid)
        .then((value) => isSelectedVerse = [!value, !!value]);
    FirebaseRepository()
        .isServanthoodCompletedForCurrentWeek(user.uid)
        .then((value) => isSelectedServanthood = [!value, !!value]);
    FirebaseRepository()
        .isPrayerOfferedForCurrentWeek(user.uid)
        .then((value) => isPrayerCompleted = [!value, !!value]);
    super.initState();
  }

  Future<List<bool>> getVerseMemorized() async {
    await FirebaseRepository()
        .isVerseMemorizedForCurrentWeek(user.uid)
        .then((value) => isSelectedVerse = [!value, !!value]);
    return isSelectedVerse;
  }

  Future<List<bool>> getServanthood() async {
    await FirebaseRepository()
        .isServanthoodCompletedForCurrentWeek(user.uid)
        .then((value) => isSelectedServanthood = [!value, !!value]);
    return isSelectedServanthood;
  }

  Future<List<bool>> getIsPrayerCompleted() async {
    await FirebaseRepository()
        .isPrayerOfferedForCurrentWeek(user.uid)
        .then((value) => isPrayerCompleted = [!value, !!value]);
    return isPrayerCompleted;
  }

  Future<String> getServanthoodCommitment() async {
    String servanthoodCommitment =
        await FirebaseRepository().getServanthoodCommitment(user.uid);
    return servanthoodCommitment;
  }

  Future<List<String>> getPrayerList() async {
    List<dynamic> prayerList =
        await FirebaseRepository().getPrayerList(user.uid);
    return prayerList.map((e) => e.toString()).toList();
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
              child: FutureBuilder<List<bool>>(
                  future: getVerseMemorized(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ToggleButtons(
                          borderColor: Colors.black,
                          fillColor: Colors.white,
                          borderWidth: 1,
                          selectedBorderColor: Color.fromRGBO(234, 197, 103, 1),
                          selectedColor: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36.0, vertical: 0),
                              child: Text(
                                'Not Yet',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Montserrat"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36.0, vertical: 0),
                              child: Text(
                                'I did it!',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Montserrat"),
                              ),
                            ),
                          ],
                          onPressed: (int index) {
                            FirebaseRepository()
                                .markVerseMemorized(user.uid, index == 1);
                            setState(() {
                              for (int i = 0; i < isSelectedVerse.length; i++) {
                                isSelectedVerse[i] = i == index;
                              }
                            });
                          },
                          isSelected: isSelectedVerse);
                    } else {
                      return CircularProgressIndicator();
                    }
                  })), // toggle button
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
          FutureBuilder(
              future: getServanthoodCommitment(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: Text(
                      snapshot.data == null
                          ? 'Input a servanthood data in Profile'
                          : snapshot.data,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return Wrap();
                }
              }),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: FutureBuilder<List<bool>>(
                future: getServanthood(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ToggleButtons(
                      borderColor: Colors.black,
                      fillColor: Colors.white,
                      borderWidth: 1,
                      selectedBorderColor: Color.fromRGBO(234, 197, 103, 1),
                      selectedColor: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 0),
                          child: Text(
                            'Not Yet',
                            style: TextStyle(
                                fontSize: 12, fontFamily: "Montserrat"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 0),
                          child: Text(
                            'I did it!',
                            style: TextStyle(
                                fontSize: 12, fontFamily: "Montserrat"),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        FirebaseRepository().markServanthoodCommitmentCompleted(
                            user.uid, index == 1);
                        setState(() {
                          for (int i = 0;
                              i < isSelectedServanthood.length;
                              i++) {
                            isSelectedServanthood[i] = i == index;
                          }
                        });
                      },
                      isSelected: isSelectedServanthood,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
          SizedBox(height: 50),
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
          Align(
              alignment: Alignment.centerLeft,
              child: FutureBuilder<List<String>>(
                  future: getPrayerList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                              snapshot.data == null
                                  ? 'Add your prayers from profile'
                                  : formatPrayerList(snapshot.data),
                              style: TextStyle(
                                color: Color(0xffC4C4C4),
                                fontSize: 14,
                              )));
                    } else {
                      return Wrap();
                    }
                  })),

          SizedBox(height: 20),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: FutureBuilder<List<bool>>(
                  future: getIsPrayerCompleted(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ToggleButtons(
                          borderColor: Colors.black,
                          fillColor: Colors.white,
                          borderWidth: 1,
                          selectedBorderColor: Color.fromRGBO(234, 197, 103, 1),
                          selectedColor: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36.0, vertical: 0),
                              child: Text(
                                'Not Yet',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Montserrat"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36.0, vertical: 0),
                              child: Text(
                                'I did it!',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Montserrat"),
                              ),
                            ),
                          ],
                          onPressed: (int index) {
                            FirebaseRepository()
                                .markPrayerCompleted(user.uid, index == 1);
                            setState(() {
                              for (int i = 0;
                                  i < isPrayerCompleted.length;
                                  i++) {
                                isPrayerCompleted[i] = i == index;
                              }
                            });
                          },
                          isSelected: isPrayerCompleted);
                    } else {
                      return CircularProgressIndicator();
                    }
                  })), // to
          SizedBox(height: 30)
        ]),
      ))));

  String formatPrayerList(List<String> prayerList) {
    return prayerList.join(", ");
  }
}
