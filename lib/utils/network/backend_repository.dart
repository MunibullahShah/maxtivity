import 'dart:async';

import 'package:maxtivity/constants/endpoints.dart';

import '../../modules/login/model/login_model.dart';
import 'backend_calls.dart';

class BackendRepository {
  Future<String> login(
      {required String email, required String password}) async {
    try {
      var response = await BackendCall().postRequest(
        endpoint: loginEndpoint,
        body: {
          "email": email,
          "password": password,
        },
      );
      return response;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      var response =
          await BackendCall().postRequest(endpoint: signUpEndpoint, body: {
        "name": name,
        "email": email,
        "password": password,
      });
      return response;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  getHistory() async {
    try {
      var response = await BackendCall()
          .getRequest(endpoint: historyEndpoint, tokenRequired: true);
      return response;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
