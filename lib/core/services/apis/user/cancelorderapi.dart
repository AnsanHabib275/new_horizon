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

class CancelOrder {
  static Future CancelOrderapi(orderid, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Create Order',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Uid Key not found in SharedPreferences');
    }

    var cancelorderdata = {"uid": uid, "order_id": orderid};

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.cancelorder);

    final response = await apiClient.post(
      Api_Constants.cancelorder,
      apiKey: apiKey,
      cancelorderdata,
    );

    if (response.statusCode == 200) {
      var canceljson = json.decode(response.body);

      ansiColorDisabled = false;
      debugPrint(success(canceljson.toString()));

      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Cancelled Order',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      return canceljson;
    } else {
      context.loaderOverlay.hide();
      var canceljson = json.decode(response.body);
      var errorcode = response.statusCode;
      ansiColorDisabled = false;
      debugPrint(warning(canceljson.toString() + errorcode.toString()));
      Fluttertoast.showToast(
          msg: 'Failed to Cancel Order',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      return null;
    }
  }
}
