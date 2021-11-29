import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'helper/authenticate.dart';
import 'helper/sharedPrefFuncitons.dart';
import 'views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  bool lockScreenEnabled;
  FirebaseAuth mAuth = FirebaseAuth.instance;

  Future _signInAnonymously() async {
    mAuth.signInAnonymously().then((_) async {
      print("Signied In Anonymasly");
    }).catchError((e) {
      print('Error: $e');
    });
  }

  @override
  void initState() {
    getLoggedInState();
    _signInAnonymously()
        .then((_) => print("done"))
        .catchError((e) => print("error"));
    super.initState();
  }

  Future getLoggedInState() async {
    await SharedPrefFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: Constants.lightTheme,
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? Home()
              : Authenticate()
          : Authenticate(),
    );
  }
}
