import 'package:flutter/material.dart';
import 'scoreboard.dart';
import 'log.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ScoreboardWidget(),
    LogWidget(),
    ProfileWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onNavBarPressed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.bar_chart_rounded),
            label: 'Scoreboard',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_rounded),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void onNavBarPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
