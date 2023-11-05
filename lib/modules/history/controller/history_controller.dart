import 'package:get/get.dart';
import 'package:maxtivity/modules/history/repository/history_repository.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getHistory();
    super.onInit();
  }

  void getHistory() async {
    isLoading.value = true;
    try {
      var data = await HistoryRepository().getHistory();
    } catch (e) {
      isLoading.value = false;
      print("Error in History: $e");
    }
  }
}
