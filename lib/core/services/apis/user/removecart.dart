// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/countercartcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:loader_overlay/loader_overlay.dart';

class RemovefromCart {
  static Future removeCart(prod_id, quantity, BuildContext context) async {
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
          msg: 'Something went Wrong! Cant Load Fav',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Email Key not found in SharedPreferences');
    }

    var removecartdata = {
      "product_id": prod_id,
      "uid": uid,
      "quantity": quantity
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.removefromcart);

    final response = await apiClient.post(
        Api_Constants.removefromcart, apiKey: apiKey, removecartdata);

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body);
      log(productsJson.toString());

      final counterController = Get.find<CounterController>();
      counterController.loadCartProducts();

      //   final cartController = Get.find<CartController>();
      // cartController.removeProduct();
      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Failed to Remove Product from Cart',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Failed to add product to cart');
    }
  }
}
