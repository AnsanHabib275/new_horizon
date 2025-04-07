// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/verifiedpatients.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class VerifiedPatientException implements Exception {
  final String message;
  final int? code;

  VerifiedPatientException({required this.message, this.code});
}

class GetVerifiedPatients {
  static Future<List<VerifiedPatient>> getVerifiedPatients(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load.',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw VerifiedPatientException(
        message: 'API Key not found in SharedPreferences',
      );
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw VerifiedPatientException(
        message: 'UID not found in SharedPreferences',
      );
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.verifiedpatients);
    final response = await apiClient.get(
      Api_Constants.verifiedpatients,
      apiKey: apiKey,
      params: {'uid': uid},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);
      return responseJson
          .map((json) => VerifiedPatient.fromJson(json))
          .toList();
    } else if (response.statusCode == 400) {
      context.loaderOverlay.hide();
      throw VerifiedPatientException(
        message: 'Verification required before proceeding',
        code: response.statusCode,
      );
    } else {
      throw VerifiedPatientException(
        message: 'Failed to load verified patients',
        code: response.statusCode,
      );
    }
  }
}
