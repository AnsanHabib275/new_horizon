// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:http/http.dart' as http;

class GetApiClient {
  final String Url;

  GetApiClient({required this.Url});

  Future<http.Response> get(String url,
      {String? apiKey, Map<String, String>? params}) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    if (apiKey != null) {
      headers['api-key'] = apiKey;
    }

    Uri uri = Uri.parse(url);

    if (params != null && params.isNotEmpty) {
      uri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: params,
      );
    }

    final response = await http.get(
      uri,
      headers: headers,
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
