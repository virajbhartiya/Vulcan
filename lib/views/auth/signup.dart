import 'dart:math';
import 'package:chatapp/views/auth/chooseProPic.dart';

import '../../funcitons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helper/sharedPrefFuncitons.dart';
// import '../../services/auth.dart';
import '../../helper/firebase_helper.dart';
import '../../widget/widget.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../home.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final firestore = Firestore.instance;

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  // AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  Future<bool> usernameExists(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  String createCryptoRandomString([int length = 32]) {
    Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  signUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (!(await usernameExists(usernameEditingController.text))) {
        String uid = createCryptoRandomString();

        firestore
            .collection("users")
            .document(usernameEditingController.text)
            .setData({
          "email": emailEditingController.text,
          "password": hash(passwordEditingController.text),
          "username": usernameEditingController.text,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "uid": uid,
          "profilePic": "",
        });
        SharedPrefFunctions.saveUserLoggedInSharedPreference(true);
        SharedPrefFunctions.saveUserNameSharedPreference(
            usernameEditingController.text);
        SharedPrefFunctions.saveUidSharedPreference(uid);
        SharedPrefFunctions.saveUserEmailSharedPreference(
            emailEditingController.text);
        SharedPrefFunctions.saveUserPassSharedPreference(
            passwordEditingController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "User exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hola.",
                      style: GoogleFonts.workSans(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 90,
                      ),
                    ),
                    Spacer(),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return (val.trim().length > 0)
                                  ? null
                                  : "You Have A Name Right?";
                            },
                            minLines: 1,
                            controller: usernameEditingController,
                            decoration:
                                textFieldDecoration(context, "Username"),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.workSans(
                              color: Theme.of(context).colorScheme.primary,
                              textBaseline: TextBaseline.ideographic,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            minLines: 1,
                            // maxLines: 999999999999999999,
                            controller: emailEditingController,
                            decoration:
                                textFieldDecoration(context, "Email ID"),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.workSans(
                              color: Theme.of(context).colorScheme.primary,
                              textBaseline: TextBaseline.ideographic,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (val) {
                              return null;
                              // String pattern =
                              //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                              // RegExp regExp = new RegExp(pattern);
                              // return (regExp.hasMatch(val))
                              //     ? null
                              //     : "Weak password";
                            },
                            obscureText: true,
                            minLines: 1,
                            controller: passwordEditingController,
                            decoration:
                                textFieldDecoration(context, "Password"),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.workSans(
                              color: Theme.of(context).colorScheme.primary,
                              textBaseline: TextBaseline.ideographic,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary
                            ],
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.workSans(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: GoogleFonts.workSans(
                                color: Theme.of(context).colorScheme.primary)),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Sign in",
                            style: GoogleFonts.workSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
