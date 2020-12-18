import 'package:flutter/material.dart';
import 'package:winterchallenge/core/services/auth.dart';
import 'package:winterchallenge/ui/screens/home.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:winterchallenge/core/data/database.dart';

final firebaseRepository = new FirebaseRepository();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#EAC567"),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/klesis_white.png"), height: 172.0),
              SizedBox(height: 50),
              _signInGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInGoogleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        await signInWithGoogle().then((auth.User firebaseUser) async {
          if (firebaseUser != null) {
            // If it is a new user, create a user in the database
            if (firebaseRepository.getUserDetails(firebaseUser.uid) != null) {
              print('Creating new user in Database');
              firebaseRepository.createUserWithGoogleProvider(firebaseUser);
            }
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Home();
            }));
          }
        });
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
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
    );
  }
}
