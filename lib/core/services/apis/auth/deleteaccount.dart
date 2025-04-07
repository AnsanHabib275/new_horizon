// ignore_for_file: camel_case_types, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/core/services/userpreferences/userpreference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/post_api_call.dart';

class Deleteaccount_Api {
  static Future<bool> deleteaccountapi(
    BuildContext context,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');
    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Please Re-login',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Please Re-login',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('Email Key not found in SharedPreferences');
    }

    var deleteaccountdata = {"uid": 'gvhg'};

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.deleteaccount);
    final response = await apiClient.post(
      Api_Constants.deleteaccount,
      apiKey: apiKey,
      deleteaccountdata,
    );

    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body);
      await UserPreferences().clearCredentials();
      AppNavigatorService.navigateToReplacement(Route_paths.signup);
      context.loaderOverlay.hide();
      return true;
    } else {
      return false;
    }
  }
}
