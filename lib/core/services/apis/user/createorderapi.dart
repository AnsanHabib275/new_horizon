// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/services/apis/api_call_type/post_api_call.dart';
import 'package:new_horizon/ui/utils/logcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:loader_overlay/loader_overlay.dart';

class CreateOrder {
  static Future Createneworder(
      useremail,
      bvid,
      region,
      fname,
      lname,
      saddress,
      baddress,
      city,
      postcode,
      phnumber,
      totprice,
      savaddress,
      billing_firstname,
      billing_lastname,
      billing_city,
      billing_postalcode,
      biilling_phone,
      usrnote,
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Create Order',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
          msg: 'Something went Wrong! Cant Create Order',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Email Key not found in SharedPreferences');
    }

    var createcartdata = {
      "uid": uid,
      "bv_id": bvid,
      "order_email": useremail,
      "country": region,
      "first_name": fname,
      "last_name": lname,
      "shipping_address": saddress,
      "billing_address": baddress,
      "city": city,
      "postal_code": postcode,
      "phone_number": phnumber,
      "total_price": totprice,
      "save_address": true,
      "delivery_type": "1",
      "scheduled_date": "",
      "billing_first_name": billing_firstname,
      "billing_last_name": billing_lastname,
      "billing_city": billing_city,
      "billing_postal_code": billing_postalcode,
      "billing_phone_number": biilling_phone,
      "billing_state": "state",
      "note": usrnote,
    };

    PostApiClient apiClient = PostApiClient(Url: Api_Constants.Createcart);

    final response = await apiClient.post(
      Api_Constants.Createcart,
      apiKey: apiKey,
      createcartdata,
    );

    if (response.statusCode == 200) {
      var productsJson = json.decode(response.body); // changed to var

      ansiColorDisabled = false;
      debugPrint(success(productsJson.toString()));

      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: 'Ordered Successfully',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      return productsJson;
    } else {
      context.loaderOverlay.hide();
      var productsJson = json.decode(response.body); // changed to var
      var errorcode = response.statusCode;
      ansiColorDisabled = false;
      debugPrint(warning(productsJson.toString() + errorcode.toString()));
      Fluttertoast.showToast(
          msg: 'Failed to Order from Cart',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      return null;
      // throw Exception('Failed to add product to cart');
    }
  }
}
