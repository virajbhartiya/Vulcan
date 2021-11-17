import 'package:chatapp/helper/sharedPrefFuncitons.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldpassController = new TextEditingController();
  TextEditingController newpassController = new TextEditingController();
  TextEditingController repassController = new TextEditingController();

  String oldPass;
  @override
  void initState() {
    super.initState();
    getOldPass();
  }

  getOldPass() async {
    oldPass = await SharedPrefFunctions.getUserPassSharedPreference();
  }

  final _formKey = GlobalKey<FormState>();
  submit() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (_formKey.currentState.validate()) {
      if (oldpassController.text == oldPass) {
        user.updatePassword(repassController.text).then((_) {
          SharedPrefFunctions.saveUserPassSharedPreference(
              repassController.text);
        }).catchError((error) {
          print(error.toString());
          Fluttertoast.showToast(
            msg: "Please Log in again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).colorScheme.primary,
            fontSize: 16.0,
          );
        });
        Fluttertoast.showToast(
          msg: "Password Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColorDark,
          textColor: Theme.of(context).colorScheme.primary,
          fontSize: 16.0,
        );
        Navigator.of(context).pop();
      }
    } else
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Password.",
          style: GoogleFonts.workSans(
            fontSize: 50,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                minLines: 1,
                validator: (val) {
                  if (val == null || val.length == 0) return "Can't be empty";
                  if (val != oldPass) return "Wrong password";
                  return null;
                },
                controller: oldpassController,
                decoration: textFieldDecoration(
                  context,
                  "Current Password",
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                style: GoogleFonts.workSans(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (val) {
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  return (regExp.hasMatch(val)) ? null : "Weak password";
                },
                minLines: 1,
                controller: newpassController,
                decoration: textFieldDecoration(
                  context,
                  "New Password",
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                style: GoogleFonts.workSans(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                minLines: 1,
                validator: (val) {
                  if (val == null || val.length == 0) return "Can't be Empty";
                  if (val != newpassController.text)
                    return 'Password Don\'t match';
                  return null;
                },
                controller: repassController,
                decoration: textFieldDecoration(
                  context,
                  "Re-Type new Password",
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                style: GoogleFonts.workSans(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  submit();
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
                    "Change Password",
                    style: GoogleFonts.workSans(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
