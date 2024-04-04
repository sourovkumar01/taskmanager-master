import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/Data/Models/UserData.dart';

class AuthControllers {
  static String? accessToken;
  static UserData? userData;

  static Future<void> SaveUserData(UserData userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("UserData", jsonEncode(userData.toJson()));
    AuthControllers.userData = userData;
  }

  static Future<UserData?> GetUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? result = sharedPreferences.getString("UserData");
    if (result == null) {
      return null;
    }
    final user = UserData.fromJson(jsonDecode(result));
    AuthControllers.userData = user;
    return user;
  }

  static Future<void> SaveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("token", token);
    accessToken = token;
  }

  static Future<String?> GetUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }

  static Future<bool> isUserLoggedin() async {
    final result = await GetUserToken();
    accessToken = result;

    bool loginState = result != null;
    if (loginState) {
      await GetUserData();
    }
    return loginState;
  }

  static Future<void> ClearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
