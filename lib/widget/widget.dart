import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../consts.dart';

void showToast(message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(Constants.appName + '.'),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldDecoration(context, label, {suffix, fill, fillColor}) {
  return InputDecoration(
    suffix: suffix,
    filled: fill ?? false,
    fillColor: fillColor ?? Colors.transparent,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100),
      ),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
    border: InputBorder.none,
    hintText: label,
    hintStyle: GoogleFonts.workSans(
      color: Theme.of(context).colorScheme.primary,
    ),
    contentPadding: const EdgeInsets.only(
      left: 18,
      right: 20,
      top: 14,
      bottom: 14,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.workSans(color: Colors.white54),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

capitalize(String s) {
  return s.length > 0 ? s[0].toUpperCase() + s.substring(1) : s.toUpperCase();
}
