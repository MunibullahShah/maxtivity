import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/login/view/login_view.dart';

import '../../../utils/services/local_storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        // Prefer Firebase auth state; fallback to stored token if needed
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          Get.off(() => HomeView());
        } else {
          final token = await LocalStorageService().getToken() ?? "";
          if (token.isNotEmpty) {
            Get.off(() => HomeView());
            return;
          }
          Get.off(() => LoginView());
        }
      },
    );
    super.onInit();
  }
}
