// Import the firebase_core plugin
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String year;
  final String gender;

  UserData(this.id, this.firstName, this.lastName, this.year, this.gender);

  String getId() {
    return this.id;
  }

  String getFirstName() {
    return this.firstName;
  }

  String getLastName() {
    return this.lastName;
  }

  String getYear() {
    return this.year;
  }

  String getGender() {
    return this.gender;
  }

  Map<String, dynamic> getDataMap() {
    return {
      "id": getId(),
      "firstName": getFirstName(),
      "lastName": getLastName(),
      "year": getYear(),
      "gender": getGender()
    };
  }
}

class Database {
  final CollectionReference USERS_COLLECTION = firestore.collection('users');
  final CollectionReference COMMITMENTS_COLLECTION =
      firestore.collection('commitment');
  final CollectionReference PRAYERS_COLLECTION = firestore.collection('prayer');
  final CollectionReference RESULTS_COLLECTION = firestore.collection('result');
  final CollectionReference VERSES_COLLECTION = firestore.collection('verse');
  final CollectionReference POINTS_COLLECTION =
      firestore.collection('POINTS_COLLECTION');

  /// CREATE FUNCTIONS

  /// Initializes a user in the database (user_data, empty prayer list, 0 POINTS_COLLECTION, record for the week they were initialized)
  void createUser(UserData user, String commitment, int week) {
    USERS_COLLECTION.doc(user.getId()).set(user.getDataMap());
    PRAYERS_COLLECTION.doc(user.getId()).set({"prayer_list": []});
    POINTS_COLLECTION.doc(user.getId()).set({"points": 0});
    createRecord(user, week);
  }

  /// Initialize user record of given week (default none completed)
  void createRecord(UserData user, int week) {
    RESULTS_COLLECTION.doc(user.getId() + week.toString()).set({
      "user_id": user.getId(),
      "week": week,
      "verse": "False",
      "commitment": "False",
      "prayer": "False"
    });
  }

  /// Initializes or updates the commitment of a user in the database
  void setCommitment(UserData user, String commitment) {
    COMMITMENTS_COLLECTION.doc(user.getId()).set({"commitment": commitment});
  }

  /// Sets the verse for the given week
  void setVerse(int week, String verse) {
    VERSES_COLLECTION.doc(week.toString()).set({"verse": verse});
  }

  /// UPDATE FUNCTIONS

  /// Records the user has completed their verse on given week
  void verseComplete(UserData user, int week) {
    RESULTS_COLLECTION
        .doc(user.getId() + week.toString())
        .update({"verse": "True"});
  }

  /// Records the user has completed their commitment on given week
  void commitmentComplete(UserData user, int week) {
    RESULTS_COLLECTION
        .doc(user.getId() + week.toString())
        .update({"commitment": "True"});
  }

  /// Records the user has completed their prayer on given week
  void prayerComplete(UserData user, int week) {
    RESULTS_COLLECTION
        .doc(user.getId() + week.toString())
        .update({"prayer": "True"});
  }

  /// Adds name on the prayer_list of the given user in the database
  void addPrayer(UserData user, String pray_for) async {
    var prayer_list;

    await getPrayerList(user).then((result) {
      prayer_list = result;
    });

    prayer_list = prayer_list.add(pray_for);

    PRAYERS_COLLECTION.doc(user.getId()).update({"prayer_list": prayer_list});
  }

  /// Add points of a given user by points parameter. Returns the user's new total number of points.
  Future<int> addPoints(UserData user, int points) async {
    int user_points;

    await getPoints(user).then((result) {
      user_points = result;
    });

    POINTS_COLLECTION.doc(user.getId()).update({"points": user_points});
    return user_points;
  }

  /// Updates commitment of user in database
  void updateCommitment(UserData user, String commitment) {
    COMMITMENTS_COLLECTION.doc(user.getId()).update({"commitment": commitment});
  }

  /// GET FUNCTIONS

  /// Returns commitment of user as a string
  Future<String> getCommitment(UserData user) async {
    var commitment;

    await COMMITMENTS_COLLECTION.doc(user.getId()).get().then((document) {
      if (document.exists) {
        document.get(commitment);
      }
    });

    return commitment;
  }

  /// Returns Prayer List of user
  Future<List<String>> getPrayerList(UserData user) async {
    List<String> prayer_list = List();

    await PRAYERS_COLLECTION.doc(user.getId()).get().then((document) {
      if (document.exists) {
        prayer_list = document.get("prayer_list");
      }
    });

    return prayer_list;
  }

  /// Returns current number of POINTS_COLLECTION of user
  Future<int> getPoints(UserData user) async {
    int user_points;
    await POINTS_COLLECTION.doc(user.getId()).get().then((document) {
      if (document.exists) {
        user_points = document.get("points");
      }
    });

    return user_points;
  }

  /// Returns boolean indicating completion of prayer commitment for given week
  Future<bool> getPrayerResult(UserData user, int week) async {
    bool prayer;
    await RESULTS_COLLECTION
        .doc(user.getId() + week.toString())
        .get()
        .then((document) {
      if (document.exists) {
        prayer = document.get("prayer");
      }
    });

    return prayer;
  }

  /// Returns boolean indicating completion of prayer commitment for given week
  Future<bool> getCommitmentResult(UserData user, int week) async {
    bool commitment;

    await RESULTS_COLLECTION
        .doc(user.getId() + week.toString())
        .get()
        .then((document) {
      if (document.exists) {
        commitment = document.get("commitment");
      }
    });

    return commitment;
  }

  /// Returns boolean indicating completion of prayer commitment for given week
  Future<bool> getVerseResult(UserData user, int week) async {
    bool verse;

    await RESULTS_COLLECTION
        .doc(user.getId() + week.toString())
        .get()
        .then((document) {
      if (document.exists) {
        verse = document.get("verse");
      }
    });

    return verse;
  }

  Future<String> getVerse(int week) async {
    var verse;
    await VERSES_COLLECTION.doc(week.toString()).get().then((document) {
      if (document.exists) {
        verse = document.get("verse");
      }
    });

    return verse;
  }
}
