import 'package:maxtivity/utils/network/backend_repository.dart';

class HistoryRepository {
  Future<List> getHistory() async {
    try {
      var response = await BackendRepository().getHistory();
      var decodedResponse = response;
      if (decodedResponse['status'] == "400" ||
          decodedResponse['status'] == "500" ||
          decodedResponse['status'] == "300") {
        return [];
      }
      return decodedResponse['message'];
    } catch (e) {
      throw Exception(e);
    }
  }
}
