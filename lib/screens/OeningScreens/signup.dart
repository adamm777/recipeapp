import 'package:capstone/screens/OeningScreens/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  final SharedPreferences prefs;
  const SignUpPage({super.key, required this.prefs});

  @override
  State<SignUpPage> createState() => _SignUpPageState(prefs);
}

class _SignUpPageState extends State<SignUpPage> {
  final SharedPreferences prefs;
  _SignUpPageState(this.prefs);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Future<User?> signUpWithEmail(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      // you can add your statements here
      Fluttertoast.showToast(
          msg: "Password does not match. Please re-type again.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else {
      final FirebaseAuth auth = FirebaseAuth.instance;
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;

        if (user != null) {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (_, __, ___) => SignInPage(
                    prefs: prefs,
                  )));
        }
        // ignore: use_build_context_synchronously

        return user;
      } catch (e) {
        print(e);
        return null;
      }
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
                      'Sign Up',
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
                    const Padding(padding: EdgeInsets.all(8.0)),
                    const Text(
                      "Repeat Password",
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
                          controller: _confirmPasswordController,
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
              const Padding(padding: EdgeInsets.all(8.0)),

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
                    signUpWithEmail(
                        _emailController.text,
                        _passwordController.text,
                        _confirmPasswordController.text);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => SignInPage(
                              prefs: prefs,
                            )));
                  },
                  child: const Text(
                    "Already Have an Account? Sign In!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Popins"),
                  ),
                ),
              ),
              // const SizedBox(height: 16),
              // OutlinedButton(
              //   onPressed: () {
              //     // Navigate to sign up page
              //     // Navigator.of(context).pushReplacement(PageRouteBuilder(
              //     //     pageBuilder: (_, __, ___) => new SignUpPage()));
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              //     child: Text(
              //       'Sign Up',
              //       style: TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
