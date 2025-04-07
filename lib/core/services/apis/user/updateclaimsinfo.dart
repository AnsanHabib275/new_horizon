// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateClaimsinfo {
  static Future Updateclaiminf(order_id, claimsubmitteddate, claimpaiddate,
      claimbilledamount, claimpaidamount, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Update Details',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Update Details',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('uid Key not found in SharedPreferences');
    }

    var updationdata = {
      "uid": uid.toString(),
      "order_id": order_id,
      "date_billed": claimsubmitteddate,
      "amount_billed": claimbilledamount,
      "date_paid": claimpaiddate,
      "amount_paid": claimpaidamount
    };
    PostApiClient apiClient =
        PostApiClient(Url: Api_Constants.updateclaimdetails);
    final response = await apiClient.post(
        Api_Constants.updateclaimdetails, apiKey: apiKey, updationdata);

    if (response.statusCode == 200) {
      var updateresult = json.decode(response.body);
      log(updateresult.toString());

      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Updated Successfully',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);

      AppNavigatorService.pop();
    } else {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Updation Failed',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      var errorResponse = json.decode(response.body);
      print(errorResponse.toString());
      AppNavigatorService.navigateToReplacement(Route_paths.billing);
    }
  }
}
