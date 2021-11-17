import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/googlesheet.dart';
import 'package:chatapp/helper/sharedPrefFuncitons.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/views/lockscreens/setPin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgotPassword.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool enabled = false;
  TextEditingController pinController = new TextEditingController();
  String currentPin;

  googleSheets() async {
    String index =
        await SharedPrefFunctions.getGoogleSheetIndexSharedPreference();
    FormConstructor formConstructor =
        FormConstructor(pin: "none", toDo: "lock", index: index);
    FormController formController = FormController("lock");
    formController.submit(formConstructor);
  }

  @override
  void initState() {
    super.initState();
    getValues();
  }

  getValues() async {
    bool val =
        (await SharedPrefFunctions.getPinEnabledSharedPreference()) ?? false;
    currentPin = await SharedPrefFunctions.getPin();
    setState(() {
      currentPin = currentPin;
      enabled = val;
    });
  }

  changeValues() async {
    await SharedPrefFunctions.savePinEnabledSharedPreference(!enabled)
        .then((value) {
      setState(() {
        enabled = !enabled;
        pinController.text = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          "Settings.",
          style: GoogleFonts.workSans(
            fontSize: 50,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Sign Out"),
                                  content: Text(
                                      "Are you sure you want to Sign Out?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        textStyle: MaterialStateProperty.all<
                                                TextStyle>(
                                            TextStyle(color: Colors.black)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .backgroundColor),
                                      ),
                                      onPressed: () {
                                        SharedPrefFunctions
                                            .savePinEnabledSharedPreference(
                                                false);
                                        AuthService().signOut();

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Authenticate(),
                                          ),
                                        );
                                      },
                                      child: Text("Sign Out"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          leading: Image.asset('assets/icons/sign-out.png',
                              height: 30),
                          title: Text(
                            "SignOut",
                            style: GoogleFonts.workSans(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Divider(indent: 70, color: Colors.grey),
                        ListTile(
                          dense: true,
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ChangePassword()));
                          },
                          leading: Image.asset(
                              'assets/icons/change-password.png',
                              height: 25),
                          title: Text(
                            "Change Password",
                            style: GoogleFonts.workSans(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Divider(indent: 70, color: Colors.grey),
                        ListTile(
                          trailing: Switch(
                              value: enabled,
                              onChanged: (value) async {
                                if (!enabled == true) {
                                  changeValues();
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => SetPin()));
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Enter Pin"),
                                        content: TextField(
                                          onSubmitted: (String value) async {
                                            currentPin =
                                                await SharedPrefFunctions
                                                    .getPin();
                                            if (value == currentPin) {
                                              changeValues();
                                              googleSheets().then((_) {
                                                Navigator.pop(context);
                                              });
                                            } else {}
                                          },
                                          controller: pinController,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          cursorColor: Colors.green[50],
                                          decoration: InputDecoration(
                                            fillColor: Theme.of(context)
                                                .backgroundColor,
                                            filled: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                              borderSide: BorderSide(
                                                color: Color(0xff06d6a7),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Current Pin",
                                            hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 18,
                                              right: 20,
                                              top: 14,
                                              bottom: 14,
                                            ),
                                          ),
                                          keyboardType: TextInputType.phone,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancle"),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              textStyle: MaterialStateProperty
                                                  .all<TextStyle>(TextStyle(
                                                      color: Colors.black)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .backgroundColor),
                                            ),
                                            onPressed: () async {
                                              currentPin =
                                                  await SharedPrefFunctions
                                                      .getPin();
                                              if (pinController.text ==
                                                  currentPin) {
                                                changeValues();
                                                googleSheets().then((_) {
                                                  Navigator.pop(context);
                                                });
                                              } else {}
                                            },
                                            child: Text("Disable"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              }),
                          dense: true,
                          leading:
                              Image.asset('assets/icons/lock.png', height: 25),
                          title: Text(
                            "Lock",
                            style: GoogleFonts.workSans(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
