import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:winterchallenge/core/data/database.dart';
import 'package:tuple/tuple.dart';
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

  String servanthoodCommitment;
  List<String> prayerList;

  Tuple2 thisWeekVerse;
  int currentWeek;

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

  Future<void> initStateForLog() async {
    await FirebaseRepository()
        .isVerseMemorizedForCurrentWeek(user.uid)
        .then((value) => isSelectedVerse = [!value, !!value]);
    await FirebaseRepository()
        .isServanthoodCompletedForCurrentWeek(user.uid)
        .then((value) => isSelectedServanthood = [!value, !!value]);
    await FirebaseRepository()
        .isPrayerOfferedForCurrentWeek(user.uid)
        .then((value) => isPrayerCompleted = [!value, !!value]);
    this.servanthoodCommitment =
        await FirebaseRepository().getServanthoodCommitment(user.uid);
    List<dynamic> prayerList =
        await FirebaseRepository().getPrayerList(user.uid);
    this.prayerList =
        prayerList == null ? [] : prayerList.map((e) => e.toString()).toList();
    this.thisWeekVerse = await FirebaseRepository().getVerseOfTheWeek();
    this.currentWeek = FirebaseRepository().getCurrentWeekNumber();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: const Text(
            'Track your progress',
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light),
      body: FutureBuilder(
          future: initStateForLog(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return getLogPage();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }));

  SingleChildScrollView getLogPage() {
    return SingleChildScrollView(
        child: Center(
            child: Container(
                width: 350.0,
                color: Colors.white,
                child: Column(children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Week ' + this.currentWeek.toString(),
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          this.thisWeekVerse.item2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      this.thisWeekVerse.item1,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Memory Verses',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text('memorized this week\'s verse',
                                  style: getSubTextStyle()))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 40.0),
                          child: ToggleButtons(
                              borderColor: Colors.black,
                              fillColor: Color.fromRGBO(234, 197, 103, 1),
                              borderWidth: 0,
                              selectedBorderColor: Colors.black,
                              selectedColor: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0, vertical: 0),
                                  child: Text(
                                    'Not Yet',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: "Montserrat"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0, vertical: 0),
                                  child: Text(
                                    'I did it!',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: "Montserrat"),
                                  ),
                                ),
                              ],
                              onPressed: (int index) {
                                FirebaseRepository()
                                    .markVerseMemorized(user.uid, index == 1);
                                setState(() {
                                  for (int i = 0;
                                      i < isSelectedVerse.length;
                                      i++) {
                                    isSelectedVerse[i] = i == index;
                                  }
                                });
                              },
                              isSelected: isSelectedVerse)), // toggle button
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Servanthood',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          this.servanthoodCommitment == null
                              ? 'Input a servanthood data in Profile'
                              : this.servanthoodCommitment,
                          style: getSubTextStyle(),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 40.0),
                        child: ToggleButtons(
                          borderColor: Colors.black,
                          fillColor: Color.fromRGBO(234, 197, 103, 1),
                          borderWidth: 0,
                          selectedBorderColor: Colors.black,
                          selectedColor: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36.0, vertical: 0),
                              child: Text(
                                'Not Yet',
                                style: TextStyle(
                                    fontSize: 14, fontFamily: "Montserrat"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36.0, vertical: 0),
                              child: Text(
                                'I did it!',
                                style: TextStyle(
                                    fontSize: 14, fontFamily: "Montserrat"),
                              ),
                            ),
                          ],
                          onPressed: (int index) {
                            FirebaseRepository()
                                .markServanthoodCommitmentCompleted(
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
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Prayer',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                  this.prayerList == null
                                      ? 'Add your prayers from profile'
                                      : formatPrayerList(this.prayerList),
                                  style: getSubTextStyle()))),

                      SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: ToggleButtons(
                              borderColor: Colors.black,
                              fillColor: Color.fromRGBO(234, 197, 103, 1),
                              borderWidth: 0,
                              selectedBorderColor: Colors.black,
                              selectedColor: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0, vertical: 0),
                                  child: Text(
                                    'Not Yet',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: "Montserrat"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0, vertical: 0),
                                  child: Text(
                                    'I did it!',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: "Montserrat"),
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
                              isSelected: isPrayerCompleted)), // to
                      SizedBox(height: 30)
                    ]),
                  )
                ]))));
  }

  String formatPrayerList(List<String> prayerList) {
    return prayerList.join(", ");
  }

  TextStyle getSubTextStyle() {
    return TextStyle(
      color: Color(0xffC4C4C4),
      fontSize: 14,
      fontFamily: "Montserrat",
    );
  }
}
