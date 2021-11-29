import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFunctions {
  static String loginStateKey = "LOGINSTATEKEY";
  static String usernameKey = "USERNAMEKEY";
  static String emailIDKey = "EMAILIDKEY";
  static String passwordKey = "PASSWORDKEY";
  static String pinKey = "PINKEY";
  static String pinStateKey = "PINSTATEKEY";
  static String uidKey = "UIDKEY";
  static String decryptKeyKey = "DECRYPTKEYKEY";

  // saving data to sharedpreference
  static Future<bool> saveLoginState(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(loginStateKey, isUserLoggedIn);
  }

  static Future<bool> saveUsername(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(usernameKey, userName);
  }

  static Future<bool> saveUID(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(uidKey, uid);
  }

  static Future<bool> saveEmailID(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailIDKey, email);
  }

  static Future<bool> savePassword(String userPass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(passwordKey, userPass);
  }

  static Future<bool> savePin(String pin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(pinKey, pin);
  }

  static Future<bool> savePinState(bool index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(pinStateKey, index);
  }

  static Future<bool> saveDecryptKey(String deviceFingerprint) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(decryptKeyKey, deviceFingerprint);
  }

  /// fetching data from sharedpreference

  static Future<bool> getLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getBool(loginStateKey);
  }

  static Future<String> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(usernameKey);
  }

  static Future<String> getUID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(uidKey);
  }

  static Future<String> getPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(passwordKey);
  }

  static Future<String> getEmailID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(emailIDKey);
  }

  static Future<String> getPin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(pinKey);
  }

  static Future<bool> getPinState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getBool(pinStateKey);
  }

  static Future<String> getDecryptKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await preferences.getString(decryptKeyKey);
  }
}
