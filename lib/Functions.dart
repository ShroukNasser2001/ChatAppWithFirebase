import 'package:shared_preferences/shared_preferences.dart';

class Functions {
  static String userLoggedInKey = "LOGGRDINKEY";
  static String userFirstNameKey = "USERFIRSTNAMEKEY";
  static String userLastNameKey = "USERLASTNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserFirstName(String userFirstName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userFirstNameKey, userFirstName);
  }

  static Future<bool> saveUserLastName(String userLastName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userLastNameKey, userLastName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
