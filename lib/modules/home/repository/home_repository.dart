import 'dart:convert';

import 'package:maxtivity/utils/network/backend_repository.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class HomeRepository {
  Future<String> saveTime(DateTime startTime, DateTime endTime) async {
    try {
      var response = await BackendRepository().saveTime(startTime, endTime);
      var decodedResponse = jsonDecode(response);
      if (decodedResponse['status'] == "400" ||
          decodedResponse['status'] == "500" ||
          decodedResponse['status'] == "300") {
        return "";
      }
      return decodedResponse['status'];
    } catch (e) {
      getErrorSnackbar(title: "Error", message: "SomethingWentWrong");
      throw Exception(e);
    }
  }
}
