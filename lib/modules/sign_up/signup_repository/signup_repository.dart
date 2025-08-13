import 'dart:convert';

import 'package:maxtivity/utils/models/user_model.dart';
import 'package:maxtivity/utils/network/backend_repository.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class SignUpRepository {
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      var response = await BackendRepository()
          .signUp(name: name, email: email, password: password);
      var decodedResponse = jsonDecode(response);
      if (decodedResponse['status'] == "400" ||
          decodedResponse['status'] == "500" ||
          decodedResponse['status'] == "300") {
        getErrorSnackbar(
            title: "Error",
            message: decodedResponse['message']["error"].toString());
        return "";
      }
      return decodedResponse['message']["token"];
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
