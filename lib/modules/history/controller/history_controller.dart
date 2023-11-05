import 'package:get/get.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';
import 'package:maxtivity/modules/history/repository/history_repository.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;

  List<HistoryModel> historyList = [];
  @override
  void onInit() {
    getHistory();
    super.onInit();
  }

  void getHistory() async {
    isLoading.value = true;
    try {
      historyList = await HistoryRepository().getHistory();
      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      print("Error in History: $e");
    }
  }
}
