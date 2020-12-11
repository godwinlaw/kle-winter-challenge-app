/// The UI for the login page. 
/// Uses auth.dart to authenticate using a Google login

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Login with Google')), body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseUser user;

  /// When the login page is loaded for the first time for the app instance,
  /// make sure no user is logged in
  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  /// Prompts user with Google sign-in page, then redirect
  /// to the home page on a successful authentication
  void click() {
    signInWithGoogle().then((user) => {
      this.user = user,
      // Redirect to home page
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => Home(user)))
    });
  }

  /// A click-able Google Login button
  Widget googleLoginButton() {
    return OutlineButton(
      onPressed: this.click,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      splashColor: Colors.grey,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/google_logo.png'), height: 35),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Sign in with Google',
              style: TextStyle(color: Colors.grey, fontSize: 25)))
          ],
    )));
  }

  /// Show the login button on start
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: googleLoginButton());
  }
}