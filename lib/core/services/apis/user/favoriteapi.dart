// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/favmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class GetFavProdApi {
  static Future<List<FavModel>> getfavProdapi(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

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
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('uid Key not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.getfavorite);
    final response = await apiClient
        .get(Api_Constants.getfavorite, apiKey: apiKey, params: {'uid': uid});

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List productsJson = json.decode(response.body);
      return productsJson.map((product) => FavModel.fromJson(product)).toList();
    } else {
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('error_code') &&
          responseBody['error_code'] == 4011) {
        return []; // return empty list to indicate no products found
      } else {
        // your existing error handling
        throw Exception('Failed to load products');
      }
    }
  }
}
