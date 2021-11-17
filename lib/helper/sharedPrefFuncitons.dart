import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserPassKey = "USEREPASSKEY";
  static String sharedPreferencePinKey = "PIN";
  static String sharedPreferenceGoogleIndexKey = "GOOGELSHEETINDEXKEY";
  static String sharedPreferencePinEnabledKey = "PINENABLEDKEY";
  static String sharedPreferenceUidKey = "UIDKEY";

  // saving data to sharedpreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUidSharedPreference(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUidKey, uid);
  }

  static Future<bool> saveUserEmailSharedPreference(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, email);
  }

  static Future<bool> saveUserPassSharedPreference(String userPass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserPassKey, userPass);
  }

  static Future<bool> savePin(String pin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencePinKey, pin);
  }

  static Future<bool> saveGoogleSheetIndexSharedPreference(String index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceGoogleIndexKey, index);
  }

  static Future<bool> savePinEnabledSharedPreference(bool index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPreferencePinEnabledKey, index);
  }

  /// fetching data from sharedpreference

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUidSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(sharedPreferenceUidKey);
  }

  static Future<String> getUserPassSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(sharedPreferenceUserPassKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getPin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(sharedPreferencePinKey);
  }

  static Future<String> getGoogleSheetIndexSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(sharedPreferenceGoogleIndexKey);
  }

  static Future<bool> getPinEnabledSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getBool(sharedPreferencePinEnabledKey);
  }
}
