import 'package:capstone/screens/OeningScreens/ChooseSignInOrSignUp.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SharedPreferences prefs;
  SettingsPage({required this.prefs});
  @override
  State<SettingsPage> createState() => _SettingsPageState(prefs);
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;
  _SettingsPageState(this.prefs);
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _logoutFromGoogle() async {
    await _googleSignIn.signOut();
    prefs.clear();
    Navigator.of(context).pop();

    Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChooseSignInorSignUp(
              prefs: prefs,
            )));
    // Add any additional logout logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                title: const Text(
                  "SETTINGS",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 28.0),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0.5,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _logoutFromGoogle();
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
                        const Text(
                          "Logout",
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
              ),
            ],
          ),
        ));
  }
}
