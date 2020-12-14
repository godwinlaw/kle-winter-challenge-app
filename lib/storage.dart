import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String year;
  final String gender;


  User(this.id, this.firstName, this.lastName, this.year, this.gender);

  String id() {
    return this.id
  }

  String first_name() {
    return this.firstName;
  }

  String last_name() {
    return this.lastName;
  }

  String year() {
    return this.year;
  }

  String gender() {
    return this.gender;
  }

  Map<String, dynamic> getDataMap() {
    return {"id": id(), "firstName": first(), "lastName": last(), 
    "year": year(), "gender": gender()};
  }

}


class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference users = firestore.collection('users');
  final CollectionReference commitments = firestore.collection('commitment');
  final CollectionReference prayers = firestore.collection('prayer');
  final CollectionReference results = firestore.collection('result');
  final CollectionReference verses = firestore.collection('verse');
  final CollectionReference points = firestore.collection('points');


  /// CREATE FUNCTIONS

  /// Initializes a user in the database (user_data, empty prayer list, 0 points, record for the week they were initialized)
  void createUser(User user, String commitment, int week) {
    users.doc(user.id()).set(user.getDataMap());
    prayers.doc(user.id()).set({"prayer_list": []);
    points.doc(user.id()).set({"points": 0});
    createRecord(user, week);
  }

  /// Initialize user record of given week (default none completed)
  void createRecord(User user, int week) {
    results.doc(user.id() + week.toString()).set(
        {"user_id": user.id(), "week": week, "verse": False, "commitment": False, "prayer": False});
  }

  /// Initializes or updates the commitment of a user in the database
  void setCommitment(User user, String commitment) {
    commitments.doc(user.id()).set({"commitment":commitment});
  }

  /// Sets the verse for the given week
  void setVerse(int week, String verse) {
    verses.doc(week).set({"verse": verse});
  }


  /// UPDATE FUNCTIONS

  /// Records the user has completed their verse on given week
  void verseComplete(User user, int week) {
    results.doc(user.id() + week.toString()).update({"verse": True});
  }

  /// Records the user has completed their commitment on given week
  void commitmentComplete(User user, int week) {
    results.doc(user.id() + week.toString()).update({"commitment": True});
  }

  /// Records the user has completed their prayer on given week
  void prayerComplete(User user, int week) {
    results.doc(user.id() + week.toString()).update({"prayer": True});
  }

  /// Adds name on the prayer_list of the given user in the database
  void addPrayer(User user, String pray_for) {
    var prayer_list = getPrayerList(user);
    prayer_list = prayer_list.add(pray_for);
    prayers.doc(user.id()).update({"prayer_list": prayer_list});
  }

  /// Add points of a given user by points parameter. Returns the user's new total number of points.
  int addPoints(User user, int points) {
    int user_points += getPoints(user) + points;
    points.doc(user.id()).update({"points": user_points});
    return user_points;
  }

  /// Updates commitment of user in database
  void updateCommitment(User user, String commitment) {
    commitments.doc(user.id()).update({"commitment":commitment});
  }
  


  /// GET FUNCTIONS
  

  /// Returns commitment of user as a string
  String getCommitment(User user) {
    var commitment = commitments.doc(user.id()).get().data.data();
    return commitment;
  }

  /// Returns Prayer List of user
  var getPrayerList(User user) {
    var prayer_list = prayers.doc(user.id()).get().data.data()["prayer_list"];
    return prayer_list;

  /// Returns current number of points of user
  int getPoints(User user) {
    int user_points = points.doc(user.id()).get().data.data()["points"];
    return user_points;

  /// Returns boolean indicating completion of prayer commitment for given week
  bool getPrayerResult(User user, int week) {
    bool prayer = results.doc(user.id() + week.toString()).get().data.data()["prayer"];
    return prayer;
  }

  /// Returns boolean indicating completion of prayer commitment for given week
  bool getCommitmentResult(User user, int week) {
    bool commitment = results.doc(user.id() + week.toString()).get().data.data()["commitment"];
    return commitment;
  }

  /// Returns boolean indicating completion of prayer commitment for given week
  bool getVerseResult(User user, int week) {
    bool verse = results.doc(user.id() + week.toString()).get().data.data()["verse"];
    return verse;
  }

  String getVerse(int week) {
    var verse = verses.doc(week).get().data.data()["verse"];
    return verse;
  }

}