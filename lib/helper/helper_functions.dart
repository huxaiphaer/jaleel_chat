import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencesUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //saving data to shared preferences.

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameInSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }

  static Future<bool> saveUserEmailInSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  // Getting data from Shared preferences.

  static Future<bool> getUserLoggedInInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserEmailKey);
  }
}
