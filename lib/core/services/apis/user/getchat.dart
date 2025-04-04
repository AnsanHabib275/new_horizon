// ignore_for_file: use_build_context_synchronously

import 'package:new_horizon/core/models/ChatMessagesModel.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class GetAllChat implements Exception {
  final String message;
  final int? code;

  GetAllChat({required this.message, this.code});
}

class GetExistingChat {
  static Future<List<ChatModel>> fetchChatMessages(BuildContext context) async {
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
      throw GetAllChat(message: 'API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Load',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw GetAllChat(message: 'UID not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.getAllchat);
    final response = await apiClient
        .get(Api_Constants.getAllchat, apiKey: apiKey, params: {'uid': uid});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((message) => ChatModel.fromJson(message))
          .toList();
    } else if (response.statusCode == 400) {
      context.loaderOverlay.hide();
      throw GetAllChat(
        message: 'Verification required before proceeding',
        code: response.statusCode,
      );
    } else {
      throw GetAllChat(
        message: 'Failed to load verified patients',
        code: response.statusCode,
      );
    }
  }
}
