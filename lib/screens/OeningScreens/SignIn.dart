// ignore: file_names
import 'package:capstone/screens/OeningScreens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BottomNavBArScreens/BottomNavBAr.dart';

class SignInPage extends StatefulWidget {
  final SharedPreferences prefs;
  const SignInPage({super.key, required this.prefs});

  @override
  // ignore: no_logic_in_create_state
  State<SignInPage> createState() => _SignInPageState(prefs);
}

class _SignInPageState extends State<SignInPage> {
  SharedPreferences prefs;
  _SignInPageState(this.prefs);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => bottomNavigationBar(
                  prefs: prefs,
                )));

        print('User signed in with Google: ${user?.displayName}');
        // Use the access token to authenticate the user on your server.
      } else {
        print("the user is = to null");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<User?> signInWithEmail(
      BuildContext context, String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var a = userCredential.user?.uid;
      print(a);
      prefs.setString("UID", a.toString());
      print(prefs.getString("UID").toString() + "Hello Hello ");
      User? user = userCredential.user;

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => bottomNavigationBar(
                prefs: prefs,
              )));

      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 30.0)),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: 130,
                        child: Image.asset('assets/images/Logo.png')),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      " Email",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    SizedBox(
                      width: 350.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.orange,
                            width: 2.0,
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    SizedBox(
                      width: 350.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.orange,
                            width: 2.0,
                          ),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2.0)),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    horizontal: 100.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.orange.shade300,
                ),
                child: TextButton(
                  onPressed: () {
                    signInWithEmail(context, _emailController.text,
                        _passwordController.text);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    ),
                  ),
                  const Text(
                    " Or ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.2,
                        fontFamily: 'Sans',
                        fontSize: 17.0),
                  ),
                  Container(
                    color: Colors.black,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    ),
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
                    _handleGoogleSignIn();
                  },
                  child: buttonCustomGoogle()),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => SignUpPage(
                              prefs: prefs,
                            )));
                  },
                  child: const Text(
                    "Do Not have account? Sign up!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Popins"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class buttonCustomGoogle extends StatelessWidget {
  const buttonCustomGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Container(
        alignment: FractionalOffset.center,
        height: 49.0,
        width: 500.0,
        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
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
              "With Google",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
          ],
        ),
      ),
    );
  }
}
