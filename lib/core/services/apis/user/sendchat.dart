// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:loader_overlay/loader_overlay.dart';

class SendChatMessage {
  static Future Sendchat(msg_cont, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Load Fav',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Load Fav',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Email Key not found in SharedPreferences');
    }

    var sendmsgdata = {
      "uid": uid,
      "message_content": msg_cont,
    };
    PostApiClient apiClient = PostApiClient(Url: Api_Constants.sendmsgdata);

    final response = await apiClient.post(
        Api_Constants.sendmsgdata, apiKey: apiKey, sendmsgdata);

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body);
      log(productsJson.toString());

      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Failed to Send Message',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Failed to Send Message');
    }
  }
}
