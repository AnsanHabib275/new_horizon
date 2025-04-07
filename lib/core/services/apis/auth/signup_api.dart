// ignore_for_file: camel_case_types, unused_import, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/post_api_call.dart';

class Api_signup {
  static Future<bool> signupapicall(
    String firstname,
    String email,
    String password,
    String companyname,
    BuildContext context,
  ) async {
    var signupuserdata = {
      "full_name": firstname,
      "email": email,
      "password": password,
      "company": companyname,
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.signupurl);
    final response = await apiClient.post(
      Api_Constants.signupurl,
      signupuserdata,
    );

    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body);
      final uid = parsedResponse['uid']; // Extract the uid

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('name', firstname);
      prefs.setString('uid', uid);
      AppNavigatorService.navigateToReplacement(Route_paths.otpscreen);

      return true;
    } else {
      final parsedResponse = jsonDecode(response.body);
      if (parsedResponse['error_code'] == 3083) {
        throw Exception(
          "YOUR_ACCOUNT_ALREADY_EXISTS_AND_IS_VERIFIED_ALREADY_PLEASE_SIGN_IN_TO_CONTINUE",
        );
      } else if (parsedResponse['error_code'] == 3084) {
        // changed 'error_coode' to 'error_code'
        throw Exception(
          "YOUR_ACCOUNT_ALREADY_EXISTS_BUT_IT_IS_NOT_VERIFIED_WE_HAVE_SENT_YOU_ANOTHER_EMAIL_PLEASE_VERIFIY_YOUR_ACCOUNT",
        );
      } else if (parsedResponse['error_code'] == 3064) {
        // changed 'error_coode' to 'error_code'
        throw Exception("INVALID_EMAIL");
      }

      throw Exception("Something Went Wrong");
    }
  }
}
