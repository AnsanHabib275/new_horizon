// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/orderdetailsbyuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class CartException implements Exception {
  final String message;
  final int? code;

  CartException({required this.message, this.code});
}

class GetOrderByUid {
  static Future<List<Order>> OrderIdByUid() async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Fav',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Fav',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('Email not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.orderbyuid);
    final response = await apiClient.get(
      Api_Constants.orderbyuid,
      apiKey: apiKey,
      params: {'uid': uid},
    );
    print("Raw JSON response: ${response.body}");

    if (response.statusCode == 200) {
      // final List<dynamic> responseJson = json.decode(response.body);
      // return responseJson.map((json) => Order.fromJson(json)).toList();

      final List<dynamic> responseJson = json.decode(response.body);
      // List<Order> orders =
      //     responseJson.map((json) => Order.fromJson(json)).toList();
      List<Order> orders =
          responseJson.map((json) => Order.fromJson(json)).toList();

      // Sorting the orders in descending order based on the order date
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      return orders;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: "Something Went Wrong");
      throw CartException(message: "Bad Request", code: 400);
    } else {
      Fluttertoast.showToast(msg: "error");
      throw CartException(message: "Unknown Error", code: response.statusCode);
    }
  }
}
