import 'dart:convert';

import 'package:maxtivity/modules/history/model/history_model.dart';
import 'package:maxtivity/utils/network/backend_repository.dart';

class HistoryRepository {
  Future<List<HistoryModel>> getHistory() async {
    try {
      var response = await BackendRepository().getHistory();
      var decodedResponse = jsonDecode(response);
      if (decodedResponse['status'] == "400" ||
          decodedResponse['status'] == "500" ||
          decodedResponse['status'] == "300") {
        return [];
      }
      List<HistoryModel> historyList = [];
      decodedResponse['message']["data"].forEach((element) {
        historyList.add(HistoryModel.fromJson(element));
      });
      return historyList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
