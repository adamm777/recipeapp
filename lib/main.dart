// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:capstone/screens/BottomNavBArScreens/BottomNavBAr.dart';
import 'package:capstone/screens/BottomNavBArScreens/Home.dart';
import 'package:capstone/screens/OeningScreens/ChooseSignInOrSignUp.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome Screen',
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SharedPreferences prefs;

  Future<void> navigatorpage() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("UID") == null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ChooseSignInorSignUp(
                      prefs: prefs,
                    )));
      });
    } else {
      var uid = prefs.getString("UID");
      print(uid);
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => bottomNavigationBar(
                      prefs: prefs,
                    )));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    navigatorpage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/load.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: const [
            Padding(padding: EdgeInsets.only(bottom: 500)),
            Center(
              child: Text(
                'Recipe',
                style: TextStyle(
                    fontFamily: 'OPTICoyonet',
                    fontSize: 100,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
