// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/constants/route_constants.dart';
import 'package:new_horizon/core/services/app/app_navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/productmodel.dart';
import '../api_call_type/get_api_call.dart';

class GetProductApi {
  static Future<List<Product>> getProducts(
    BuildContext context, [
    String? category,
  ]) async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    // Check for null apiKey or uid and throw an exception if necessary
    if (apiKey == null || uid == null) {
      throw Exception('Please Login Again');
    }

    // Create an instance of the API client
    GetApiClient apiClient = GetApiClient(Url: Api_Constants.products);

    final response = await apiClient.get(
      Api_Constants.products,
      apiKey: apiKey,
      params: {'uid': uid},
    );

    if (response.statusCode == 200) {
      final List productsJson = json.decode(response.body);
      List<Product> products =
          productsJson.map((json) => Product.fromJson(json)).toList();

      if (category != null && category != 'Recommended') {
        products =
            products.where((product) => product.type == category).toList();
      }

      return products;
    } else {
      context.loaderOverlay.hide();
      AppNavigatorService.navigateToReplacement(Route_paths.home);
      throw Exception('Failed to load products');
    }
  }
}
