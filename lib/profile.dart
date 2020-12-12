import 'package:flutter/material.dart';

/// Screen for viewing user profile and all their commitments.
///
/// Owners: Ashley Alvarez, Christy Koh, Chloe Chan
///

class ProfileWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileWidgetState();
  }
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String name;
  String servantHood;
  String picturePath;
  bool isBrother;
  List<String> prayerList;

  @override
  void initState() {
    super.initState();
    // todo init with user data
    name = "Godwin Law";
    isBrother = true;
    if (isBrother) {
      picturePath = "images/default_man.jpeg";
    } else {
      picturePath = "images/default_woman.jpeg";
    }
    servantHood = "";
    prayerList = [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Column(children: [
          _profilePic(picturePath),
          Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          EditableContainer()
        ]),
      );
}

Widget _profilePic(String pic) => Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(pic),
          backgroundColor: Colors.white,
          radius: 100,
        )
      ],
    );

class EditableContainer extends StatefulWidget {
  EditableContainer({Key key}) : super(key: key);

  @override
  _EditableContainerState createState() => _EditableContainerState();
}

class _EditableContainerState extends State<EditableContainer> {
  String contents;
  String servanthood;
  List<String> prayerList = [];
  bool isEditingServanthood;
  bool isEditingPrayer;

  @override
  void initState() {
    super.initState();
    // todo init with user data
    servanthood = "default servanthood commitment";
    prayerList = ["Christy Koh", "Ashley Alvarez", "Chloe Chan"];
  }

  @override
  Widget build(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width * .9,
      child: Card(
          child: Column(
        children: [
          ListTile(
            title: Text('Memory Verse'),
          ),
          ListTile(
            title: Text('Servanthood'),
            subtitle: Text("TODO make this an editable text widget"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditingServanthood = !isEditingServanthood;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Prayer'),
            subtitle: _prayerWidget(prayerList),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditingPrayer = !isEditingPrayer;
                });
              },
            ),
          ),
        ],
      )));
}

Widget _prayerWidget(List<String> people) => Row(children: [
      Text("TODO list of ppl"),
      // ListView.builder(
      //   // Let the ListView know how many items it needs to build.
      //   itemCount: people.length,
      //   // Provide a builder function. This is where the magic happens.
      //   // Convert each item into a widget based on the type of item it is.
      //   itemBuilder: (context, index) {
      //     return Text(people[index]);
      //   },
      // )
    ]);
