import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/sign_up/signup_repository/signup_repository.dart';
import 'package:maxtivity/utils/services/local_storage_service.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void hidePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  signUp() async {
    isLoading.value = true;

    try {
      jwtToken = await SignUpRepository().signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text);
      isLoading.value = false;
      if (jwtToken.isNotEmpty) {
        LocalStorageService().setToken(jwtToken);
        Get.offAll(() => HomeView());
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.back();
    }
  }
}
