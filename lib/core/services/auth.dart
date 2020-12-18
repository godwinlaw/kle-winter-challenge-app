import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
auth.User firebaseUser;

String name;
String email;
String photoUrl;

Future<auth.User> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final auth.GoogleAuthCredential credential =
      auth.GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final auth.User user = (await _auth.signInWithCredential(credential)).user;
  print('Successfully signed in user with Google Provider');
  print('Name: ${user.displayName} | uID: ${user.uid}');

  // Return the current user, which should now be signed in with Google
  firebaseUser = auth.FirebaseAuth.instance.currentUser;

  return firebaseUser;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User signed out");
}
