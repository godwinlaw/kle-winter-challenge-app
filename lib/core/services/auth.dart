import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:winterchallenge/core/data/database.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final firebaseRepository = new FirebaseRepository();

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

Future<auth.User> signInWithApple() async {
  // Sign In with Apple is only supported on iOS 13+
  if (await AppleSignIn.isAvailable()) {
    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print('Apple credentials authorized');
            final AppleIdCredential appleIdCredential = result.credential;

            // Store Apple Credetial uID
            // Store user ID
            await FlutterSecureStorage().write(
                key: "appleCredentialUid", value: result.credential.user);

            // Create Apple AuthCredential to sign into Firebase using Apple credentials
            auth.OAuthProvider oAuthProvider =
                new auth.OAuthProvider('apple.com');
            final auth.AuthCredential credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            // Sign into Firebase using Apple credentials
            final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
            final auth.UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            final auth.User firebaseUser = userCredential.user;
            print(
                '${firebaseUser.uid} successfully signed in user with Apple Provider');

            var userDetails =
                await firebaseRepository.getUserDetails(firebaseUser.uid);
            if (userDetails == null) {
              // Update the UserInfo with Apple profile information on the first sign in
              String newDisplayName =
                  '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';

              await firebaseUser
                  .updateProfile(displayName: newDisplayName)
                  .catchError((error) => print(error));

              // Refresh data
              await firebaseUser.reload();

              auth.User updatedUser = auth.FirebaseAuth.instance.currentUser;

              print(
                  'Updated UserProfile info | Name: ${updatedUser.displayName}');

              print('Creating new user in Database');

              firebaseRepository.createUserWithAppleProvider(updatedUser);
            }

            auth.User updatedUser = auth.FirebaseAuth.instance.currentUser;

            // Return the updated user
            return updatedUser;
          } catch (e) {
            print('error');
          }
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } catch (error) {
      print('error with apple sign in');
    }
  } else {
    print('Apple SignIn is not available for your device');
  }

  // If there is an error, return null for FirebaseUser
  return null;
}
