import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../funcitons.dart';
import '../../helper/sharedPrefFuncitons.dart';
// import '../../services/auth.dart';
import '../home.dart';
import '../../widget/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final firebase = Firestore();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  // AuthService authService = new AuthService();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      final DocumentReference document = Firestore.instance
          .collection("users")
          .document(usernameEditingController.text);

      await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
        if (snapshot.data == null) {
          // Do something with the data
        } else {
          snapshot.data.forEach((key, value) {
            if (key == "password") {
              if (value == hash(passwordEditingController.text)) {
                SharedPrefFunctions.saveUserLoggedInSharedPreference(true);
                SharedPrefFunctions.saveUserNameSharedPreference(
                    usernameEditingController.text);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              } else {
                Fluttertoast.showToast(
                    msg: "Invalid Password",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                setState(() {
                  isLoading = false;
                });
              }
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
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
                              return null;
                              // return RegExp(
                              //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //         .hasMatch(val)
                              //     ? null
                              //     : "Please Enter Correct Email";
                            },
                            minLines: 1,
                            controller: usernameEditingController,
                            decoration:
                                textFieldDecoration(context, "Username"),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.workSans(
                              color: Theme.of(context).colorScheme.primary,
                              // textBaseline: TextBaseline.ideographic,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return null;
                              // return val.length > 6
                              //     ? null
                              //     : "Enter Password 6+ characters";
                            },
                            minLines: 1,
                            controller: passwordEditingController,
                            decoration:
                                textFieldDecoration(context, 'Password'),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.workSans(
                              color: Theme.of(context).colorScheme.primary,
                              textBaseline: TextBaseline.ideographic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
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
                            )),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Sign In",
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
                        Text("Don't have an account? ",
                            style: GoogleFonts.workSans(
                                color: Theme.of(context).colorScheme.primary)),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Register now",
                            style: GoogleFonts.workSans(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
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
