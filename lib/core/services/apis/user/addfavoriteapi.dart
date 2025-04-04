// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/favouritteitemcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFavouriteapi {
  static Future AddFavourite(prod_id, BuildContext context) async {
    // Retrieve the API key from SharedPreferences
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
          msg: 'Something went Wrong! Cant Add Products',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('uid Key not found in SharedPreferences');
    }

    var favdata = {
      "product_id": prod_id,
      "uid": uid,
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.addfavoriteapi);
    final response = await apiClient.post(
        Api_Constants.addfavoriteapi, apiKey: apiKey, favdata);

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body);
      log(productsJson.toString());
      final Favcartcounter favcontroller = Get.put(Favcartcounter());
      favcontroller.loadFavProducts(context);
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Added Successfully',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
    } else {
      context.loaderOverlay.hide();

      var errorResponse = json.decode(response.body);

      if (errorResponse['error_code'] == 4012) {
        Fluttertoast.showToast(
            msg: 'Product already exists in the favorites!',
            webPosition: 'right',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color.fromARGB(255, 0, 49, 77),
            fontSize: 14);
      } else {
        // Handle other general errors
        Fluttertoast.showToast(
            msg: 'Failed to Add',
            webPosition: 'right',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color.fromARGB(255, 0, 49, 77),
            fontSize: 14);
        context.loaderOverlay.hide();
      }

      // throw Exception('Failed to add product');
    }
  }
}
