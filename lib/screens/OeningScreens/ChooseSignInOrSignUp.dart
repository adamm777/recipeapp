// ignore: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../BottomNavBArScreens/BottomNavBAr.dart';

class ChooseSignInorSignUp extends StatefulWidget {
  final SharedPreferences prefs;
  ChooseSignInorSignUp({super.key, required this.prefs});

  @override
  State<ChooseSignInorSignUp> createState() =>
      _ChooseSignInorSignUpState(prefs);
}

class _ChooseSignInorSignUpState extends State<ChooseSignInorSignUp> {
  SharedPreferences prefs;
  _ChooseSignInorSignUpState(this.prefs);
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      _googleSignIn.signOut();
      await _googleSignIn.signIn();
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final user = authResult.user;

        String a = user!.uid.toString();
        prefs.setString("UID", a);
        prefs.setString("name", user.displayName.toString());

        prefs.setString("email", user.email.toString());
        prefs.setString("photo", user.photoURL.toString());
        print(prefs.get("name"));
        print(prefs.get("email"));
        print(prefs.get("photo"));
        print(prefs.get("UID"));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => bottomNavigationBar(
              prefs: prefs,
            ),
          ),
        );

        // ignore: avoid_print
        print('User signed in with Google: ${user.displayName}');
        // Use the access token to authenticate the user on your server.
      } else {
        print("the user is = to null");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2)),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        children: [
                          Image.asset('assets/images/chefhat.png'),
                          Text(
                            'Recipe',
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: "Popins",
                                color: Colors.grey.shade700),
                          ),
                        ],
                      )),
                  const Padding(padding: EdgeInsets.only(top: 100.0)),
                  InkWell(
                    onTap: () {
                      _handleGoogleSignIn();
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300,
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10.0)
                          ],
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(padding: EdgeInsets.only(left: 0.0)),
                            Image.asset(
                              "assets/images/google.png",
                              height: 25.0,
                            ),
                            const Text(
                              "Continue With Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7.0)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
