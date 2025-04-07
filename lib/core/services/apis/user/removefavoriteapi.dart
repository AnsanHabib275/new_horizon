// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/favouritteitemcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:loader_overlay/loader_overlay.dart';

class Removefavorite {
  static Future Removefavoriteapi(prod_id, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Please Re-login',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Please Re-login',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('Email Key not found in SharedPreferences');
    }

    var removefavdata = {"uid": uid, "product_id": prod_id};

    PostApiClient apiClient = PostApiClient(
      Url: Api_Constants.removefavoriteapi,
    );

    final response = await apiClient.post(
      Api_Constants.removefavoriteapi,
      apiKey: apiKey,
      removefavdata,
    );

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body);
      log(productsJson.toString());
      Fluttertoast.showToast(
        msg: 'Removed from Favourites',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      final Favcartcounter favcontroller = Get.put(Favcartcounter());
      favcontroller.loadFavProducts(context);
      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
        msg: 'Failed to Remove Product from Favorites',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('Failed to Remove Product');
    }
  }
}
