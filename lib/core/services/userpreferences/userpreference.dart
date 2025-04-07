// ignore_for_file: prefer_final_fields

import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveCredentials(
      String email, String password, bool rememberMe) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("email", email);
    prefs.setString("password", password);
    prefs.setBool("rememberMe", rememberMe);
  }

  Future<String?> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("email");
  }

  Future<String?> getPassword() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("password");
  }

  Future<bool> getRememberMe() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool("rememberMe") ?? false;
  }

  Future<void> clearCredentials() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("email");
    prefs.remove("password");
    prefs.remove("rememberMe");
    prefs.remove('Api_key');
    prefs.remove('uid');
    await prefs.clear(); // Clears all of the keys
    AppNavigatorService.navigateToAndRemoveAll(Route_paths.splash2);
  }
}
