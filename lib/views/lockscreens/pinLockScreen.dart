import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home.dart';
import '../../helper/sharedPrefFuncitons.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({Key key}) : super(key: key);

  @override
  _PinLockScreenState createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  bool visible = false;
  TextEditingController pinController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  // googleSheets(String pin) async {
  //   String index = await HelperFunctions.getGoogleSheetIndexSharedPreference();

  //   FormConstructor formConstructor =
  //       FormConstructor(pin: pin, toDo: "lock", index: index);

  //   FormController formController = FormController("lock");

  //   formController.submitSignUp(formConstructor);
  // }

  submit(value) async {
    if (value != null && value != "") {
      if (value == await SharedPrefFunctions.getPin())
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => Home()));
      else {
        Fluttertoast.showToast(
          msg: "Incorrect Pin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColorDark,
          textColor: Theme.of(context).colorScheme.primary,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Pin.',
                  style: GoogleFonts.workSans(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 90,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Spacer(flex: 2),
                Form(
                  key: formKey,
                  child: TextField(
                    onSubmitted: (value) {
                      submit(value);
                    },
                    onChanged: (value) {
                      if (value.length == 4) submit(value);
                    },
                    controller: pinController,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: Theme.of(context).backgroundColor,
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
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
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                            !visible ? FeatherIcons.eye : FeatherIcons.eyeOff,
                            color: Theme.of(context).colorScheme.primary),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          setState(() {
                            visible = !visible;
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              setState(() {
                                visible = false;
                              });
                            });
                          });
                        },
                      ),
                      border: InputBorder.none,
                      hintText: "Enter the pin",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 18,
                        right: 20,
                        top: 14,
                        bottom: 14,
                      ),
                    ),
                    textCapitalization: TextCapitalization.none,
                    obscureText: !visible,
                    maxLength: 4,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Spacer(),
              ]),
        ),
      ),
    );
  }
}
