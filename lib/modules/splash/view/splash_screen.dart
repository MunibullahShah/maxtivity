import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

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
            CustomText(text: "Maxtivity", fontSize: 35),
          ],
        ),
      ),
    );
  }
}
