// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/cartproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class CartException implements Exception {
  final String message;
  final int? code;

  CartException({required this.message, this.code});
}

class GetUserCart {
  static Future<List<CartProduct>> getcart() async {
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
      throw Exception('Email not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.getmycart);
    final response = await apiClient
        .get(Api_Constants.getmycart, apiKey: apiKey, params: {'uid': uid});

    if (response.statusCode == 200) {
      final List<dynamic> responseJson = json.decode(response.body);
      List<CartProduct> initialProducts = responseJson
          .map((dynamic item) => CartProduct.fromJson(item))
          .toList();

      // Group the products by product_Id
      var groupedProducts = <String, List<CartProduct>>{};
      for (var product in initialProducts) {
        if (!groupedProducts.containsKey(product.product_Id)) {
          groupedProducts[product.product_Id] = [];
        }
        groupedProducts[product.product_Id]!.add(product);
      }

      // Create a new list where each product's quantity is the sum of all products with the same ID
      List<CartProduct> finalProducts = [];
      for (var entry in groupedProducts.entries) {
        final firstProduct = entry.value.first;
        final quantity = entry.value.length;
        finalProducts.add(CartProduct(
          imageUrl: firstProduct.imageUrl,
          name: firstProduct.name,
          price: firstProduct.price,
          product_Id: firstProduct.product_Id,
          quantity: quantity,
        ));
      }

      return finalProducts;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      if (errorResponse['error_code'] == 3088 ||
          errorResponse['error_code'] == 3089) {
        throw CartException(
            message: errorResponse['error_message'], code: 3088);
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to fetch cart',
            webPosition: 'right',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 0, 49, 77),
            fontSize: 14);
        throw CartException(message: 'Failed to load products');
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to fetch cart',
          webPosition: 'right',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 0, 49, 77),
          fontSize: 14);
      throw Exception('Failed to load products');
    }
  }
}
