// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PostApiClient {
  final String Url;
  PostApiClient({required this.Url});

  Future<http.Response> post(String url, Map<String, dynamic> body,
      {String? apiKey, Map<String, String>? params}) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    if (apiKey != null) {
      headers['api-key'] = apiKey;
    }

    // If params are provided, append them to the URL
    if (params != null && params.isNotEmpty) {
      final queryString = Uri(queryParameters: params).query;
      url = '$url?$queryString';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      log(response.body);
    } else {
      log(
        "${response.statusCode}: ${response.reasonPhrase}",
      );
    }
    return response;
  }
}
