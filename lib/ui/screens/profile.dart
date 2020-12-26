import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:winterchallenge/ui/screens/login_page.dart';
import 'package:winterchallenge/core/data/database.dart';
import '../../core/services/auth.dart';

final user = auth.FirebaseAuth.instance.currentUser;
final firebaseRepository = new FirebaseRepository();

/// Used for log out

/// Screen for viewing user profile and all their commitments.
///
/// Owners: Ashley Alvarez, Christy Koh, Chloe Chan

class ProfileWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileWidgetState();
  }
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String name;
  bool isBrother;
  ImageProvider profileImage;

  String servanthood;
  bool isEditingServanthood;

  List<String> prayerList;
  bool isEditingPrayer;

  Gender gender;
  YearInSchool year;

  @override
  void initState() {
    super.initState();
    // TODO: init with user data
    name = user.displayName;
    isBrother = true;
    photoUrl = user.photoURL;

    if (photoUrl != "") {
      profileImage = NetworkImage(photoUrl);
    } else {
      profileImage = AssetImage(
          isBrother ? "assets/default_man.jpeg" : "assets/default_woman.jpeg");
    }

    servanthood = "Code the winter challenge app";
    prayerList = ["Toby", "Michael", "Merryle", "Emilio", "Chibuzor"];
    isEditingServanthood = false;
    isEditingPrayer = false;
  }

  Future<void> initStateForProfile() async {
    gender = await firebaseRepository.getGender(user.uid);
    year = await firebaseRepository.getYear(user.uid);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                  fontSize: 20, color: Colors.black, fontFamily: "Montserrat"),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            brightness: Brightness.light),
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
              Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: Column(children: [
                    _profilePic(),
                    SizedBox(height: 10),
                    Text(
                      user.displayName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                          fontSize: 28),
                    ),
                  ])),
              individualTile(genderPicker()),
              individualTile(yearPicker()),
              // individualTile(
              //   ListTile(
              //       title: Text('Memory Verses',
              //           style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w500,
              //               color: Colors.black)),
              //       trailing: IconButton(
              //         icon: Icon(Icons.arrow_forward_ios_rounded),
              //         onPressed: () {
              //           // TODO: display memory verses in another page
              //         },
              //       )),
              // ),
              individualTile(ServanthoodWidget()),
              individualTile(_PrayerChipWidget()),
              SizedBox(height: 20),
              _logOutWidget(context)
            ])),
      );

  FutureBuilder genderPicker() {
    return FutureBuilder(
        future: initStateForProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text('Gender',
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
              RadioListTile(
                title: const Text('Male'),
                value: Gender.Male,
                groupValue: gender,
                onChanged: (Gender value) {
                  firebaseRepository.setGender(user.uid, value);
                  setState(() {
                    gender = value;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Female'),
                value: Gender.Female,
                groupValue: gender,
                onChanged: (Gender value) {
                  setState(() {
                    firebaseRepository.setGender(user.uid, value);
                    gender = value;
                  });
                },
              ),
            ]);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  FutureBuilder yearPicker() {
    return FutureBuilder(
        future: initStateForProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text('Year',
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
              yearDropdown()
            ]);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget yearDropdown() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: DropdownButton<YearInSchool>(
          value: year,
          isExpanded: true,
          elevation: 1,
          onChanged: (YearInSchool newValue) {
            firebaseRepository.setYear(user.uid, newValue);
            setState(() {
              year = newValue;
            });
          },
          items: YearInSchool.values
              .map<DropdownMenuItem<YearInSchool>>((YearInSchool value) {
            return DropdownMenuItem<YearInSchool>(
              value: value,
              child: Text(value.toString().substring(13)),
            );
          }).toList(),
        ));
  }
}

/// A button that logs the user out when pressed, then returns to login page
Widget _logOutWidget(BuildContext context) {
  return RaisedButton(
    onPressed: () async {
      // Sign out
      await signOutGoogle();
      // Return to login page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    },
    color: Color.fromRGBO(178, 59, 59, 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Log Out',
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

// adapted from scoreboard, wrapper for ListTiles
Container individualTile(Widget tileChild) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
    child: new Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: tileChild,
    ),
  );
}

Future<ImageProvider> _getProfilePic() async {
  ImageProvider result;
  await firebaseRepository.getUserDetails(user.uid).then((value) {
    bool isBrother = value["gender"] == Gender.Male;
    print("gender: " + value["gender"]);
    if (user.photoURL != null) {
      print("google photo");
      result = NetworkImage(user.photoURL);
    } else {
      print("default photo");
      result = AssetImage(
          isBrother ? "assets/default_man.jpeg" : "assets/default_woman.jpeg");
    }
  });
  return result;
}

FutureBuilder _profilePic() => FutureBuilder<Gender>(
    future: firebaseRepository.getGender(user.uid),
    builder: (context, snapshot) {
      ImageProvider img;
      if (user.photoURL != null) {
        img = NetworkImage(user.photoURL);
      } else {
        img = AssetImage("assets/default_man.jpeg");
      }

      if (snapshot.hasData) {
        Gender gender = snapshot.data;
        bool isBrother = gender == Gender.Male;
        if (user.photoURL == null) {
          img = AssetImage(isBrother
              ? "assets/default_man.jpeg"
              : "assets/default_woman.jpeg");
        }
      }

      return CircleAvatar(
        backgroundImage: img,
        backgroundColor: Colors.white,
        radius: 100,
      );
    });

class ServanthoodWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServanthoodWidgetState();
}

class _ServanthoodWidgetState extends State<ServanthoodWidget> {
  bool _isEditingText = false;
  String editText = 'Write your commitment here!';
  TextEditingController _editingController = TextEditingController();

  TextEditingController _newTextController(String init) {
    _editingController = TextEditingController(text: init);
    return _editingController;
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text('Servanthood',
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        subtitle: _servanthoodTextField(),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isEditingText = !_isEditingText;
              if (!_isEditingText) {
                firebaseRepository
                    .getServanthoodCommitment(user.uid)
                    .then((value) => editText = value);
              }
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      );

  FutureBuilder _servanthoodTextField() => FutureBuilder<String>(
      future: firebaseRepository.getServanthoodCommitment(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          editText = snapshot.data == null ? '' : snapshot.data;
          if (_isEditingText)
            return Column(children: [
              TextField(
                  onSubmitted: (newValue) {
                    setState(() {
                      editText = newValue;
                      firebaseRepository.updateServanthoodCommitment(
                          user.uid, _editingController.text);
                      _isEditingText = false;
                    });
                  },
                  autofocus: true,
                  controller: _newTextController(editText)),
              new RaisedButton(
                child: new Text("Done Editing"),
                onPressed: () {
                  setState(() {
                    editText = _editingController.text;
                    firebaseRepository.updateServanthoodCommitment(
                        user.uid, _editingController.text);
                    _isEditingText = false;
                  });
                },
              ),
            ]);
          return InkWell(
              child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    editText,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14.0,
                    ),
                  )));
        } else {
          return Column(children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ]);
        }
      });

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
}

class _PrayerChipWidget extends StatefulWidget {
  _PrayerChipWidget({Key key}) : super(key: key);
  List<String> people;

  @override
  _PrayerChipWidgetState createState() => new _PrayerChipWidgetState();
}

class _PrayerChipWidgetState extends State<_PrayerChipWidget> {
  TextEditingController _textEditingController = new TextEditingController();
  bool isEditing = false;

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  FutureBuilder buildChips() => FutureBuilder<List<String>>(
      future: firebaseRepository.getPrayerList(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Widget> chips = new List();
          widget.people = snapshot.data == null ? [] : snapshot.data;
          if (isEditing) {
            for (int i = 0; i < widget.people.length; i++) {
              InputChip actionChip = InputChip(
                label: Text(widget.people[i]),
                elevation: 5,
                pressElevation: 5,
                shadowColor: Colors.lightBlue,
                onDeleted: () {
                  widget.people.removeAt(i);
                  firebaseRepository.updatePrayerCommitment(
                      user.uid, widget.people);
                  setState(() {
                    widget.people = widget.people;
                  });
                },
              );
              chips.add(actionChip);
            }
          } else {
            // no delete
            for (int i = 0; i < widget.people.length; i++) {
              InputChip actionChip = InputChip(
                  label: Text(widget.people[i]),
                  elevation: 10,
                  pressElevation: 5);
              chips.add(actionChip);
            }
          }
          return Wrap(spacing: 6.0, children: chips);
        } else if (snapshot.hasError) {
          return Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child:
                  Text('Enter some names of people you\'d like to pray for!'),
            )
          ]);
        } else {
          return Column(children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ]);
        }
      });

  @override
  Widget build(BuildContext context) {
    Widget inner;

    if (!isEditing) {
      inner = SizedBox();
    } else {
      inner = TextFormField(
        controller: _textEditingController,
        onFieldSubmitted: (text) {
          if (widget.people == null) {
            widget.people = new List<String>();
          }
          if (widget.people.length < 5) {
            widget.people.add(text);
          }
          firebaseRepository.updatePrayerCommitment(user.uid, widget.people);
          _textEditingController.clear();
          setState(() {
            widget.people = widget.people;
          });
        },
      );
    }

    return ListTile(
      title: Text('Prayer',
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
      subtitle: Container(
        child: Column(
          children: <Widget>[buildChips(), inner],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );
  }
}
