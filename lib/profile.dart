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
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        // body: Container(color: Colors.deepOrange));
        body: Column(children: [
          _profilePic(),
          Text(
            'Godwin Law',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _interactiveContainer(),
          Row(
            children: [_prayerWidget()],
          ),
        ]),
      );
}

Widget _profilePic() => Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('images/default.png'),
          backgroundColor: Colors.white,
          radius: 100,
        )
      ],
    );

Widget _interactiveContainer() => Container(
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: const DecorationImage(
          image: NetworkImage(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
    );

StatefulWidget _prayerWidget() => Card();
