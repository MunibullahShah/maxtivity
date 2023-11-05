import 'dart:convert';

import 'package:http/http.dart';
import 'package:maxtivity/constants/app_constants.dart';

import '../../constants/endpoints.dart';

class BackendCall {
  String get _url => baseUrl;

  Uri _getUri(String endpoint) => Uri.parse('$baseUrl/$endpoint');

  Future<String> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    bool tokenRequired = false,
  }) async {
    Response? response;
    String responseStr = '';
    try {
      Uri uri = _getUri(endpoint);
      response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      responseStr = responseHandler(response);
      return responseStr;
    } catch (e) {
      print("EEEEEE: $e");
      throw Exception(e);
    }
  }

  Future<String> getRequest({
    required String endpoint,
    bool tokenRequired = false,
    String? parameters,
  }) async {
    Response? response;
    String responseStr = '';
    try {
      Uri uri;
      if (parameters != null) {
        uri = _getUri(endpoint + parameters);
      } else {
        uri = _getUri(endpoint);
        // uri = Uri.parse(endpoint);
      }
      response = await get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "x-auth-token": tokenRequired ? jwtToken : ""
        },
      );
      responseStr = responseHandler(response, endpoint: endpoint);
      return responseStr;
    } catch (e) {
      throw Exception(e);
    }
  }

  String responseHandler(Response response, {String? endpoint}) {
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return "{\"status\": \"200\" , \"message\": ${response.body}}";
    } else if (response.statusCode >= 500 && response.statusCode <= 599) {
      return "{\"status\": \"500\" , \"message\": ${response.body}}";
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      return "{\"status\": \"400\" , \"message\": ${response.body}}";
    } else if (response.statusCode >= 300 && response.statusCode <= 399) {
      return "{\"status\": \"300\" , \"message\": ${response.body}}";
    } else {
      return "0";
    }
  }
}
