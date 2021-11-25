import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class Constants {
  static String appName = "Vulcan";
  static String myName = "";
  static String personName = "";
  static String uid = "";
  static String deviceFingerprint = "";
  //Colors for theme
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xff06d6a7);
  static Color darkAccent = Color(0xff06d6a7);
  static Color lightBG = Color.fromRGBO(242, 242, 247, 1);
  static Color darkBG = Colors.black;

  static double ele = 0;

  static double ftSize = 20;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightPrimary,
    primaryColor: lightPrimary,
    colorScheme: ColorScheme.light(
      primary: lightAccent,
      secondary: lightAccent,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: lightAccent,
    ),
    primaryColorDark: Colors.black,
    bottomAppBarColor: Colors.black,
    scaffoldBackgroundColor: lightPrimary,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: lightAccent,
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: ele,
      backgroundColor: lightPrimary,
      titleTextStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: ftSize,
          fontWeight: FontWeight.w800,
          color: darkBG,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    colorScheme: ColorScheme.dark(
      primary: darkAccent,
      secondary: darkAccent,
    ),
    scaffoldBackgroundColor: darkBG,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkAccent,
    ),
    bottomAppBarColor: Colors.white,
    primaryColorDark: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: ele,
      titleTextStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: ftSize,
          fontWeight: FontWeight.w800,
          color: lightBG,
        ),
      ),
    ),
  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  static formatBytes(bytes, decimals) {
    if (bytes == 0) return 0.0;
    var k = 1024,
        dm = decimals <= 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        i = (log(bytes) / log(k)).floor();
    return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
  }
}
