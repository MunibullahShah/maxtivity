import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/login/repository/login_repository.dart';
import 'package:maxtivity/utils/services/local_storage_service.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool obscurePassword = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void hidePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  login() async {
    isLoading.value = true;
    try {
      jwtToken = await LoginRepository().login(
          email: emailController.text, password: passwordController.text);
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
