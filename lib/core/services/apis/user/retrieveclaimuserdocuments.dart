import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/userclaimdocument.dart';
import 'package:new_horizon/core/services/apis/api_call_type/get_api_call.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RetreiveClaimdocumentapi {
  static Future<DocumentsUserResponse> retreivedocApi(
      BuildContext context, orderid) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    // Handle null apiKey or uid by throwing an exception or returning Future.error()
    if (apiKey == null || uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went wrong! Can\'t load documents',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      return Future.error('API Key or User ID not found in SharedPreferences');
    }

    GetApiClient apiClient =
        GetApiClient(Url: Api_Constants.retrieveclaimuserdocuments);
    final response = await apiClient.get(
        Api_Constants.retrieveclaimuserdocuments,
        apiKey: apiKey,
        params: {'uid': uid, 'orderid': orderid});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return DocumentsUserResponse.fromJson(jsonResponse);
    } else {
      if (response.statusCode == 400) {
      } else {
        // Handle other status codes appropriately
        Fluttertoast.showToast(msg: "Something went wrong");
        return Future.error(
            'Error fetching documents: Status code ${response.statusCode}');
      }
      return Future.error('');
    }
  }
}
