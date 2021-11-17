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

  @override
  void initState() {
    getLoggedInState();
    getLockScreenState();
    super.initState();
  }

  getLoggedInState() async {
    await SharedPrefFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  getLockScreenState() async {
    await SharedPrefFunctions.getPinEnabledSharedPreference().then((value) {
      setState(() {
        lockScreenEnabled = value ?? false;
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
