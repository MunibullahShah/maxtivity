import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/splash/controller/splash_controller.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';

import '../../../../../constants/constants.dart';
import '../../../../../main.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                splashLogo,
                width: screenHeight * 0.25,
                height: screenHeight * 0.25,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            CustomText(
              text: "Maxtivity",
              fontSize: 35,
            ),
          ],
        ),
      ),
    );
  }
}
