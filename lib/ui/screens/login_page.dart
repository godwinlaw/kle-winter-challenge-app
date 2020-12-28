import 'dart:io';

import 'package:flutter/material.dart';
import 'package:winterchallenge/core/services/auth.dart';
import 'package:winterchallenge/ui/screens/home.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:winterchallenge/core/data/database.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final firebaseRepository = new FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _getButtonWidgetList();

    return Scaffold(
      body: Container(
        color: HexColor("#EAC567"),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _signInGoogleButton() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        child: RaisedButton(
          onPressed: () async {
            await signInWithGoogle().then((auth.User firebaseUser) async {
              if (firebaseUser != null) {
                // If it is a new user, create a user in the database
                var userDetails =
                    await firebaseRepository.getUserDetails(firebaseUser.uid);
                if (userDetails == null) {
                  print('Creating new user in Database');
                  firebaseRepository.createUserWithGoogleProvider(firebaseUser);
                }
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Home();
                }));
              } else {
                _buildErrorDialog(context, 'Sign in with Google failed');
              }
            });
          },
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/google_logo.png"), height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _signInAppleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: apple.AppleSignInButton(
        style: apple.ButtonStyle.black,
        cornerRadius: 40,
        type: apple.ButtonType.defaultButton,
        onPressed: () async {
          await signInWithApple().then((auth.User firebaseUser) async {
            if (firebaseUser != null) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Home();
              }));
            } else {
              _buildErrorDialog(context, 'Sign in with Apple Failed');
            }
          });
        },
      ),
    );
  }

  List<Widget> _getButtonWidgetList() {
    bool isIOS = Platform.isIOS;

    List<Widget> list = <Widget>[
      Image(image: AssetImage("assets/klesis_white.png"), height: 172.0),
      SizedBox(height: 50),
      _signInGoogleButton(),
    ];

    if (isIOS) {
      list.addAll([SizedBox(height: 20), _signInAppleButton()]);
    }

    return list;
  }
}

Future _buildErrorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title:
            Text('Error Message', style: Theme.of(context).textTheme.headline6),
        content: Text(_message, style: Theme.of(context).textTheme.bodyText1),
        actions: [
          FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    },
    context: context,
  );
}
