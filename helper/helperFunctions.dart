import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String sharedPrefUserLogKey = "ISLOGGEDIN";
  static String sharedPrefNameKey = "USERNAMEKEY";
  static String sharedPrefEmailKey = "USEREMAILKEY";

  // Saving data top shared preference
  static Future<void> saveUserLogIn(bool isLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefUserLogKey, isLoggedIn);
  }

  static Future<void> saveUserName(String username) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefNameKey, username);
  }

  static Future<void> saveUserEmail(String email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefEmailKey, email);
  }


  // Getting data fropm shared preference
  static Future<bool> getUserLogIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefUserLogKey);
  }

  static Future<String> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefNameKey);
  }

  static Future<String> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefEmailKey);
  }
}