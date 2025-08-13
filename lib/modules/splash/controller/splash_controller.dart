import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/main.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/login/view/login_view.dart';

import '../../../utils/services/local_storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        jwtToken = await LocalStorageService().getToken() ?? "";
        if (jwtToken != "") {
          Get.off(() => HomeView());
        } else {
          Get.off(() => LoginView());
        }
      },
    );
    super.onInit();
  }
}
