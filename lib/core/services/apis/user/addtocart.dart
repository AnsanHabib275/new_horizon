// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/cartcontroller.dart';
import 'package:new_horizon/ui/views/screens/viewscreens/GetxControllers/countercartcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddtoCart {
  static Future AddinCart(prod_id, quantity, BuildContext context) async {
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

    var cartdata = {
      "product_id": prod_id,
      "quantity": quantity,
      "uid": uid,
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.addtocart);

    final response =
        await apiClient.post(Api_Constants.addtocart, apiKey: apiKey, cartdata);

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body); // changed to var
      log(productsJson.toString());
      AppNavigatorService.pop();

      final counterController = Get.find<CounterController>();
      counterController.loadCartProducts();
      final cartController = Get.find<CartController>();
      cartController.loadCartProducts();

      context.loaderOverlay.hide();

      Fluttertoast.showToast(
          msg: 'Added Successfully',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
    } else {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Failed to Add Product in Cart',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);

      throw Exception('Failed to add product to cart');
    }
  }
}
