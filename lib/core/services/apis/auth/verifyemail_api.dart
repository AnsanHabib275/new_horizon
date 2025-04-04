// ignore_for_file: camel_case_types, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/post_api_call.dart';

class Api_Verifymail {
  static Future<bool> verifymail(
      String verificationCode, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? email =
        prefs.getString('email'); // Retrieve email from SharedPreferences

    if (email == null) {
      return false;
    }

    var verifyemaildata = {
      "verification_code": verificationCode,
      "email": email,
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.verifyemail);
    final response =
        await apiClient.post(Api_Constants.verifyemail, verifyemaildata);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      String apiKey = responseBody['Api_key'];
      prefs.setString('Api_key', apiKey);
      context.loaderOverlay.hide();
      AppNavigatorService.navigateToReplacement(Route_paths.signin);
      return true;
    } else {
      context.loaderOverlay.hide();
      AppNavigatorService.navigateToReplacement(Route_paths.signup);
      Fluttertoast.showToast(
          msg: 'OTP Verification Failed! Try Again',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      return false;
    }
  }
}
