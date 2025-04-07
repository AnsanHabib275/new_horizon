// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_horizon/core/constants/api_constants.dart';

import 'package:new_horizon/core/services/apis/api_call_type/get_api_call.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String product_id;
  final String product_type;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.product_type,
    required this.product_id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['product_name'],
      product_type: json['Product_type'],
      imageUrl: json['Image_Url'][0],
      price: json['price'].toDouble(),
      description: json['Product_description'],
      product_id: json['product_id'],
    );
  }
}

Future<List<Product>> fetchProducts(
  BuildContext context, [
  String? category,
]) async {
  final prefs = await SharedPreferences.getInstance();
  String? apiKey = prefs.getString('Api_key');
  String? uid = prefs.getString('uid');

  if (apiKey == null) {
    throw Exception('Key not Found! Please Re-login');
  }
  if (uid == null) {
    throw Exception('Key not Found! Please Re-login');
  }

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

    for (var product in products) {
      print('Product name: ${product.name}, type: ${product.product_type}');
    }

    // Filtering logic
    if (category != null && category != 'Recommended') {
      products =
          products
              .where(
                (product) =>
                    product.product_type.trim().toLowerCase() ==
                    category.trim().toLowerCase(),
              )
              .toList();
    }

    print('Filtered products: $products');

    return products;
  } else {
    context.loaderOverlay.hide();

    throw Exception('Failed to load Products');
  }
}
