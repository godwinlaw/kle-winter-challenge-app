import 'package:flutter/material.dart';

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
  String picturePath;

  String servanthood;
  bool isEditingServanthood;

  List<String> prayerList;
  bool isEditingPrayer;

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

    servanthood = "Code the winter challenge app";
    prayerList = ["Christy Koh", "Ashley Alvarez", "Chloe Chan"];
    isEditingServanthood = false;
    isEditingPrayer = false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profilePic(picturePath),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  Card(
                      child: Column(
                    children: [
                      ListTile(
                          title: Text('Memory Verse'),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () {},
                          )),
                      Divider(),
                      ListTile(
                        title: Text('Servanthood'),
                        subtitle:
                            Text("TODO make this an editable text widget"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEditingServanthood = !isEditingServanthood;
                            });
                          },
                        ),
                      ),
                      Divider(),
                      _PrayerChipWidget(people: prayerList),
                    ],
                  ))
                ])),
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

class _PrayerChipWidget extends StatefulWidget {
  List<String> people;

  _PrayerChipWidget({Key key, @required this.people}) : super(key: key);

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

  Widget buildChips() {
    List<Widget> chips = new List();

    if (isEditing) {
      for (int i = 0; i < widget.people.length; i++) {
        InputChip actionChip = InputChip(
          label: Text(widget.people[i]),
          elevation: 10,
          pressElevation: 5,
          shadowColor: Colors.lightBlue,
          onDeleted: () {
            widget.people.removeAt(i);

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
            pressElevation: 5,
            shadowColor: Colors.lightBlue);
        chips.add(actionChip);
      }
    }

    return Wrap(spacing: 6.0, children: chips);
  }

  @override
  Widget build(BuildContext context) {
    Widget inner;

    if (!isEditing) {
      inner = SizedBox();
    } else {
      inner = TextFormField(
        controller: _textEditingController,
        onFieldSubmitted: (text) {
          if (widget.people.length < 5) {
            widget.people.add(text);
          }
          _textEditingController.clear();

          setState(() {
            widget.people = widget.people;
          });
        },
      );
    }

    return ListTile(
      title: Text('Prayer'),
      subtitle: Container(
        width: 200,
        height: 200,
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
    );
  }
}
