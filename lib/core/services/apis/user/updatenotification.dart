// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateNotifications {
  static Future Updateusernotification(
    notificationid,
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Create Order',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Create Order',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('uid Key not found in SharedPreferences');
    }

    var updatedata = {
      "uid": uid,
      "notification_id": notificationid,
      "is_viewed": true,
    };

    PostApiClient apiClient = PostApiClient(
      Url: Api_Constants.updateusernotification,
    );

    final response = await apiClient.post(
      Api_Constants.updateusernotification,
      apiKey: apiKey,
      updatedata,
    );

    if (response.statusCode == 200) {
      var updatenotificationjson = json.decode(response.body);

      ansiColorDisabled = false;
      debugPrint(success(updatenotificationjson.toString()));

      context.loaderOverlay.hide();

      return updatenotificationjson;
    } else {
      context.loaderOverlay.hide();
      var updatenotificationjson = json.decode(response.body);
      var errorcode = response.statusCode;
      ansiColorDisabled = false;
      debugPrint(
        warning(updatenotificationjson.toString() + errorcode.toString()),
      );

      return null;
    }
  }
}
