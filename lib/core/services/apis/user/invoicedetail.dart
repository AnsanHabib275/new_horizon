// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_horizon/core/constants/api_constants.dart';
import 'package:new_horizon/core/models/invoicemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_call_type/get_api_call.dart';

class CartException implements Exception {
  final String message;
  final int? code;

  CartException({required this.message, this.code});
}

class GetInoiceByUid {
  static Future<List<InvoiceModel>> InvoiceByUid() async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('Api_key');
    String? uid = prefs.getString('uid');

    if (apiKey == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Invoices',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('API Key not found in SharedPreferences');
    }
    if (uid == null) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong! Cant Load Invoices',
        webPosition: 'right',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 49, 77),
        fontSize: 14,
      );
      throw Exception('UID not found in SharedPreferences');
    }

    GetApiClient apiClient = GetApiClient(Url: Api_Constants.invoicebyuid);
    final response = await apiClient.get(
      Api_Constants.invoicebyuid,
      apiKey: apiKey,
      params: {'uid': uid},
    );

    if (response.statusCode == 200) {
      // final List<dynamic> responseJson = json.decode(response.body);
      // return responseJson.map((json) => InvoiceModel.fromJson(json)).toList();

      final List<dynamic> responseJson = json.decode(response.body);
      List<InvoiceModel> invoices =
          responseJson.map((json) => InvoiceModel.fromJson(json)).toList();

      invoices.sort((a, b) => b.invoiceDate.compareTo(a.invoiceDate));
      return invoices;
    } else {
      // Showing more descriptive error messages based on the status code
      switch (response.statusCode) {
        case 400:
          Fluttertoast.showToast(msg: "Error 400: Bad Request");
          break;
        default:
          Fluttertoast.showToast(
            msg: "Error ${response.statusCode}: ${response.reasonPhrase}",
          );
      }
      throw Exception('Failed to load invoices');
    }
  }
}
