import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';
import 'package:maxtivity/main.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;

  List<HistoryModel> historyList = [];
  @override
  void onInit() {
    getHistory();
    super.onInit();
  }

  void getHistory() {
    isLoading.value = true;
    try {
      historyList = objectBox.historyBox.getAll();
      historyList.sort(
          (a, b) => b.startTime.compareTo(a.startTime)); // Sort by newest first
      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error in History: $e");
    }
  }

  /// Removes a single saved session and refreshes the list.
  void deleteSession(int id) {
    try {
      objectBox.historyBox.remove(id);
    } catch (e) {
      debugPrint("Error deleting session: $e");
    }
    getHistory();
  }

  /// Clears every saved session from local storage.
  void clearAll() {
    try {
      objectBox.historyBox.removeAll();
    } catch (e) {
      debugPrint("Error clearing history: $e");
    }
    getHistory();
  }
}
