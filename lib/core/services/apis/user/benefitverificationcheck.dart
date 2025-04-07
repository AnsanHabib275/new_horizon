// ignore_for_file: camel_case_types, avoid_print, use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class benefitverfication {
  static benefitsverfy(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Verification',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Verification',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('Email Key not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(
      Url: Api_Constants.benefitsverification,
    );

    final response = await apiClient.get(
      Api_Constants.benefitsverification,
      apiKey: apiKey,
      params: {'uid': uid},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);

      String status = responseJson[0]['Status'];

      if (status == "PENDING") {
        // print("New Screen");
        AppNavigatorService.pushNamed(Route_paths.pendingverification);
      } else if (status == "REJECTED") {
        AppNavigatorService.pushNamed(Route_paths.datasubmission);
      } else if (status == "VERIFIED") {
        AppNavigatorService.pushNamed(Route_paths.benefitsverficationsuccess);
      } else {
        Fluttertoast.showToast(msg: 'Something Went Wrong! Please Try Again');
        // AppNavigatorService.pushNamed(Route_paths.bottomhome);
      }
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      log(errorResponse.toString());
      if (errorResponse['error_code'] == 3082) {
        AppNavigatorService.pushNamed(Route_paths.datasubmission);
        context.loaderOverlay.hide();
      } else {
        Fluttertoast.showToast(
          msg: errorResponse['error_message'],
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14,
        );
        context.loaderOverlay.hide();
        throw Exception(errorResponse['error_message']);
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
