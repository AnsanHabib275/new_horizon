// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/patientdetails.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class Getbenefitsverificationdetails {
  static Future<List<BenefitDetails>> GetBenefitDetails(
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Add Products',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant load data',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('uid Key not found in SharedPreferences');
    }

    GetApiClient apiClient =
        GetApiClient(Url: Api_Constants.benefitsverificationdetails);
    final response = await apiClient.get(
        Api_Constants.benefitsverificationdetails,
        apiKey: apiKey,
        params: {'uid': uid});

    if (response.statusCode == 200) {
      context.loaderOverlay.hide();
      final demodata = json.decode(response.body);

      final data = json.decode(response.body) as List;
      List<BenefitDetails> benefitDetailsList =
          data.map((item) => BenefitDetails.fromJson(item)).toList();

      benefitDetailsList.sort((a, b) => b.entryDate.compareTo(a.entryDate));
      ansiColorDisabled = false;
      debugPrint(success(demodata.toString()));

      return benefitDetailsList;
    } else {
      context.loaderOverlay.hide();
      throw Exception('Failed to load Data');
    }
  }
}
