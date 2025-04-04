import 'dart:convert';
import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/notificationsmodel.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class GetNotifications {
  static Future<List<Notificationmodel>> getusernotifications(
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');
    DateTime now = DateTime.now();

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
          msg: 'Something went Wrong! Cant load Fav',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('uid Key not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.usernotifications);
    final response = await apiClient.get(Api_Constants.usernotifications,
        apiKey: apiKey, params: {'uid': uid});

    ansiColorDisabled = false;
    debugPrint(success(response.body.toString()));

    if (response.statusCode == 200) {
      final List notificationJson = json.decode(response.body);

      notificationJson.sort((a, b) {
        DateTime dateA = DateTime.parse(a['created_at']);
        DateTime dateB = DateTime.parse(b['created_at']);
        return dateB.compareTo(dateA);
      });

      final filteredNotifications = notificationJson.where((notification) {
        DateTime createdAt = DateTime.parse(notification['created_at']);
        return now.difference(createdAt).inDays <= 30;
      }).toList();

      return filteredNotifications
          .map((notification) => Notificationmodel.fromJson(notification))
          .toList();
      // return notificationJson
      //     .map((product) => Notificationmodel.fromJson(product))
      //     .toList();
    } else {
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('error_code') &&
          responseBody['error_code'] == 4011) {
        return [];
      } else {
        // your existing error handling
        throw Exception('Failed to load notifications');
      }
    }
  }
}
