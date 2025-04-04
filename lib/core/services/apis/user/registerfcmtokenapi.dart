// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';

class RegisterFcmToken {
  static Future Registerfcmtoken(fcmtoken) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong!',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
    }

    var registerfcmtoken = {"uid": uid, "fcm_token": fcmtoken};

    PostApiClient apiClient =
        PostApiClient(Url: Api_Constants.registerfirebasecloudtoken);

    final response = await apiClient.post(
        Api_Constants.registerfirebasecloudtoken,
        apiKey: apiKey,
        registerfcmtoken);

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body); // changed to var
      log(productsJson.toString());

      return productsJson;
    } else {
      return null;
    }
  }
}
