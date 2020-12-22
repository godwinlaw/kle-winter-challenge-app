import 'package:flutter/material.dart';
import 'package:winterchallenge/core/data/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// Screen for viewing the scoreboard.
///
/// Owners: Sarah Liu
class ScoreboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreboardWidgetState();
  }
}

class _ScoreboardWidgetState extends State<ScoreboardWidget> {
  final firebaseRepository = new FirebaseRepository();
  final user = auth.FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return scoreboardTab();
  }

  DefaultTabController scoreboardTab() {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Scoreboard", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.black,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    // doesn't work until cocoapods is installed and no permission to write gems
                    /*gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Colors.red, Colors.orange, Colors.amberAccent]),
                    */
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("CLASS"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GENDER"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("INDIVIDUAL"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            year(),
            gender(),
            individualYearTab(),
          ]),
        ));
  }

  DefaultTabController individualYearTab() {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
                labelColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(
                  fontSize: 17.0,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Seniors"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Juniors"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Sophs"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Freshmen"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              individual(YearInSchool.Senior),
              individual(YearInSchool.Junior),
              individual(YearInSchool.Sophomore),
              individual(YearInSchool.Freshmen),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ));
  }

// Functionality for class tab

// QUESTION: is it better to redo separately or call individual ranked data and use that?
  // DATA:
  // sums up all the points of the people in each year
  // returns a list of a list
  // the first element of the list corresponds to a list of the year in order of their points
  // the second element of the list corresponds to a list of the points in order of the points
  // the third element of the list is the number of years (should be 4 for most cases)
  // the first and second elements of the list should match up

  Future<List<List>> getYearData() async {
    List<int> points = [];
    Map<YearInSchool, int> scoresByYear;
    await firebaseRepository
        .getScoresByYear()
        .then((value) => scoresByYear = value);
    points.add(scoresByYear[YearInSchool.Senior]);
    points.add(scoresByYear[YearInSchool.Junior]);
    points.add(scoresByYear[YearInSchool.Sophomore]);
    points.add(scoresByYear[YearInSchool.Freshmen]);
    List<YearInSchool> years = [
      YearInSchool.Senior,
      YearInSchool.Junior,
      YearInSchool.Sophomore,
      YearInSchool.Freshmen
    ];
    return [years, points];
  }

  // takes in the class year and points
  // returns a tile on the class tab with the year and points
  Container classTile(YearInSchool classYear, int points) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
      child: Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 25.0, horizontal: 30.0),
          title: Text(
            classYear.toString(),
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(points.toString(),
              textScaleFactor: 1.5,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600])),
        ),
      ),
    );
  }

  FutureBuilder year() {
    return FutureBuilder<List<List>>(
        future: getYearData(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.done) {
            List<List> data = snapshot.data;
            List<YearInSchool> years = data.elementAt(0);
            List<int> points = data.elementAt(1);
            int num = 4;
            return ListView(children: <Widget>[
              // making space between tab bar and the first card (space up top)
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              for (var i = 0; i < num; i++) classTile(years[i], points[i]),
            ]);
          }
        });
  }

// Functionality for gender tab
  // DATA:
  // sums up all the points of the people of each year
  // returns a list of a list
  // the first element of the list corresponds to a list of the gender
  // the second element of the list corresponds to a list of the pointsnts
  // the first and second elements of the list should match up
  Future<List<List>> getGenderData() async {
    List<int> points = [];
    Map<Gender, int> scoresByGender;
    await firebaseRepository
        .getScoresByGender()
        .then((value) => scoresByGender = value);
    points.add(scoresByGender[Gender.Female]);
    points.add(scoresByGender[Gender.Male]);
    List<String> years = ["SISTERS", "BROTHERS"];
    return [years, points];
  }

  Container genderLogo(String gender) {
    return Container(
        child: Card(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Text(gender,
                textScaleFactor: 5.0,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black))));
  }

  Container genderTile(String gender, int points) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          genderLogo(" " + gender.substring(0, 1) + " "),
          Text(
            " ",
            textScaleFactor: 0.6,
          ),
          Text(gender,
              textScaleFactor: 1.0,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          Text(
            " ",
            textScaleFactor: 0.5,
          ),
          Text(points.toString(),
              textScaleFactor: 1.5, style: TextStyle(color: Colors.grey[700])),
          Text(
            " ",
            textScaleFactor: 10,
          ),
        ],
      ),
    );
  }

  FutureBuilder gender() {
    return FutureBuilder<List<List>>(
        future: getGenderData(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.done) {
            List<List> data = snapshot.data;
            List<String> gender = data.elementAt(0);
            List<int> points = data.elementAt(1);

            return Container(
              //padding: EdgeInsets.symmetric(vertical: 120.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  genderTile(gender.elementAt(0), points.elementAt(0)),
                  genderTile(gender.elementAt(1), points.elementAt(1))
                ],
              ),
            );
          }
        });
  }

// Functionality for individual tab

  // TODO: add in functionality for photos of people
  //    (change the leading part of the Flutter Logo; take in one more argument)
  // given name, points, and rank of an individual,
  // returns a container that creates a tile for the person on the Individual tab under their year
  Container individualTile(String name, String points, int rank) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
      child: new Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(rank.toString() + "   "),
            FlutterLogo(),
          ]),
          title: Text(
            name,
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(points.toString(),
              textScaleFactor: 1.5,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ),
      ),
    );
  }

  Future<List<List>> getIndividualData(YearInSchool year) async {
    List<String> points = [];
    List<String> names = [];
    List<Map<String, String>> individualScores;
    await firebaseRepository
        .getRankedScoreForIndividuals(year)
        .then((value) => individualScores = value);
    for (int i = 0; i < individualScores.length; i++) {
      names.add(individualScores[i][0]);
      points.add(individualScores[i][1]);
    }
    return [names, points];
  }

  FutureBuilder individual(YearInSchool year) {
    return FutureBuilder<List<List>>(
        future: getIndividualData(year),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.done) {
            List<List> data = snapshot.data;
            List<String> names = data.elementAt(0);
            List<String> points = data.elementAt(1);

            return ListView(
                // replace i with the number of individuals in the class
                children: <Widget>[
                  for (var i = 0; i < names.length; i++)
                    individualTile(
                        names.elementAt(i), points.elementAt(i), i + 1)
                ]);
          }
        });
  }
}
