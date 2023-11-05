import 'dart:convert';

import 'package:get/get.dart';
import 'package:maxtivity/utils/network/backend_repository.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class LoginRepository {
  Future<String> login(
      {required String email, required String password}) async {
    String loginResponse = await BackendRepository().login(
      email: email,
      password: password,
    );
    var decodedResponse = jsonDecode(loginResponse);
    if (decodedResponse['status'] == "400" ||
        decodedResponse['status'] == "500" ||
        decodedResponse['status'] == "300") {
      getErrorSnackbar(
          title: "Error",
          message: decodedResponse['message']["error"].toString());
      return "";
    }
    return decodedResponse['message']["token"];
  }
}
