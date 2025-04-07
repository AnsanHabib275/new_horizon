// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/claims.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class CartException implements Exception {
  final String message;
  final int? code;

  CartException({required this.message, this.code});
}

class GetClaimDetails {
  static Future<List<PatientBillingInfo>> getClaimDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Load.',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw CartException(message: 'API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Load',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw CartException(message: 'UID not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.claimdetails);
    final response = await apiClient
        .get(Api_Constants.claimdetails, apiKey: apiKey, params: {'uid': uid});

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Map the dynamic list to a list of PatientBillingInfo objects
      return jsonData.map((json) => PatientBillingInfo.fromJson(json)).toList();
    } else {
      throw CartException(
        message: 'Failed to load verified patients',
        code: response.statusCode,
      );
    }
  }
}
