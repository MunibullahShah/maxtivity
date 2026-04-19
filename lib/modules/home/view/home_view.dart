import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        return PopScope(
          canPop: !(logic.isLocked && !logic.isPaused),
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _showLockWarningDialog(context);
          },
          child: Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SidebarButton(
                        sidebarIcon: sidebarIcon,
                        onTap: () {
                          _key.currentState!.openDrawer();
                        },
                      ),
                      GestureDetector(
                        onTap: logic.toggleLock,
                        child: SvgPicture.asset(
                          lockIcon,
                          width: screenWidth * 0.06,
                          height: screenWidth * 0.06,
                          colorFilter: ColorFilter.mode(
                            logic.isLocked
                                ? AppColors().secondary
                                : AppColors().normalActive,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors().secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButton<int>(
                            value: logic.selectedTimeIndex,
                            icon: Icon(Icons.arrow_drop_down,
                                color: AppColors().secondary),
                            elevation: 3,
                            style:
                                TextStyle(color: AppColors().secondary),
                            underline: Container(height: 0),
                            onChanged: logic.isPaused
                                ? (int? index) {
                                    if (index == null) return;
                                    if (index ==
                                        logic.timeOptions.length - 1) {
                                      _showCustomTimeDialog(
                                          context, logic);
                                    } else {
                                      logic.setTimeInterval(index);
                                    }
                                  }
                                : null,
                            items: logic.timeOptions
                                .asMap()
                                .entries
                                .map<DropdownMenuItem<int>>(
                                  (entry) => DropdownMenuItem<int>(
                                    value: entry.key,
                                    child: CustomText(
                                      text: entry.key ==
                                                  logic.timeOptions
                                                          .length -
                                                      1 &&
                                              logic.customMinutes != null
                                          ? '${logic.customMinutes} min'
                                          : entry.value['label'],
                                      fontSize: 16,
                                      color: AppColors().secondary,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
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
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  (logic.isPaused)
                      ? PrimaryButton(
                          text: "Start",
                          width: screenWidth * 0.8,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.8),
                          onTap: () {
                            logic.startTimer();
                          })
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryButton(
                              text: logic.timer.isActive
                                  ? "Pause"
                                  : "Resume",
                              width: screenWidth * 0.4,
                              borderRadius: BorderRadius.circular(
                                  screenWidth * 0.8),
                              onTap: () {
                                logic.pauseTimer(
                                    pause:
                                        logic.timer.isActive ? false : true);
                              },
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            PrimaryButton(
                              text: "Reset",
                              width: screenWidth * 0.4,
                              borderRadius: BorderRadius.circular(
                                  screenWidth * 0.8),
                              onTap: () {
                                logic.resetTimer();
                              },
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCustomTimeDialog(BuildContext context, HomeController logic) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom Time'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: 'Enter minutes (1–120)',
            suffixText: 'min',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 1 && value <= 120) {
                logic.setTimeInterval(logic.timeOptions.length - 1);
                logic.setCustomTime(value);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _showLockWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Timer is running'),
        content: const Text(
            'The timer is still running. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              homeController.resetTimer();
              Get.back();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
