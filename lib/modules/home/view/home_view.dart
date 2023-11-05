import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/home/controller/home_controller.dart';
import 'package:maxtivity/utils/ui/buttons/primary_button.dart';
import 'package:maxtivity/utils/ui/buttons/side_bar_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:maxtivity/utils/ui/drawer/custom_drawer.dart';

const homeRoute = '/home';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final HomeController homeController =
      Get.put(HomeController(), permanent: true);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      assignId: true,
      builder: (logic) {
        return Scaffold(
          key: _key,
          drawer: CustomDrawer(),
          body: Container(
            height: screenHeight,
            width: double.infinity,
            margin: EdgeInsets.only(
              top: screenHeight * 0.06,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              bottom: screenHeight * 0.03,
            ),
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: SidebarButton(
                    sidebarIcon: sidebarIcon,
                    onTap: () {
                      _key.currentState!.openDrawer();
                    },
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.2,
                      width: screenHeight * 0.2,
                      child: CircularProgressIndicator(
                        color: AppColors().secondary,
                        value: logic.progressValue,
                        strokeWidth: 5,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    CustomText(
                      text: logic.getMinutes(),
                      fontSize: 18,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                (logic.isPaused)
                    ? PrimaryButton(
                        text: "Start",
                        width: screenWidth * 0.8,
                        borderRadius: BorderRadius.circular(screenWidth * 0.8),
                        onTap: () {
                          logic.startTimer();
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                            text: logic.timer.isActive ? "Pause" : "Resume",
                            width: screenWidth * 0.4,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.8),
                            onTap: () {
                              logic.pauseTimer(
                                  pause: logic.timer.isActive ? false : true);
                            },
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          PrimaryButton(
                            text: "Reset",
                            width: screenWidth * 0.4,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.8),
                            onTap: () {
                              logic.resetTimer();
                            },
                          ),
                        ],
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
