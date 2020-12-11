import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authenticates a user via Google login

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

///  Prompts a Google login to authenticate user.
///  (i.e Called when pressing "Login" button on UI)
///  Returns a valid FirebaseUser.
Future<FirebaseUser> signInWithGoogle() async {
  // Prompt user to login with a Google account
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  // Sign into Firebase with the user's Google account
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  // Double check that the Firebase user is the same as the Google user
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(currentUser.uid == user.uid);

  return user;
}

/// Sign out the user
void signOutGoogle() async {
  await googleSignIn.signOut();
}