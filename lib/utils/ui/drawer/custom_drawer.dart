import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/history/view/history_view.dart';
import 'package:maxtivity/modules/home/controller/home_controller.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/stats/view/stats_view.dart';
import 'package:maxtivity/modules/login/view/firebase_login_sheet.dart';
import 'package:maxtivity/utils/services/firebase_auth_service.dart';
import 'package:maxtivity/utils/ui/buttons/side_bar_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:sizer/sizer.dart';

import '../../../config/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: screenWidth * .86,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.04.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: screenWidth * 0.07,
                    top: screenWidth * 0.001,
                  ),
                  child: SidebarButton(
                    isBack: true,
                    sidebarIcon: crossIcon,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.025.sp,
            ),
            _navigationTile(
                iconHeight: screenWidth * 0.06,
                iconWidth: screenWidth * 0.06,
                title: "Home",
                icon: homeIcon,
                onTap: () => _navigateTo(
                      context,
                      () => Get.off(() => HomeView(),
                          transition: Transition.rightToLeft,
                          duration: 800.milliseconds,
                          curve: Curves.easeIn),
                    )),
            SizedBox(
              height: screenHeight * 0.018,
            ),
            _navigationTile(
              iconHeight: screenWidth * 0.06,
              iconWidth: screenWidth * 0.06,
              title: "History",
              icon: historyIconf,
              showBorder: true,
              onTap: () => _navigateTo(
                    context,
                    () => Get.off(() => HistoryView(),
                        transition: Transition.rightToLeft,
                        duration: 400.milliseconds,
                        curve: Curves.easeIn),
                  ),
            ),
            SizedBox(
              height: screenHeight * 0.018,
            ),
            _navigationTile(
              iconHeight: screenWidth * 0.06,
              iconWidth: screenWidth * 0.06,
              title: "Statistics",
              materialIcon: Icons.bar_chart_rounded,
              showBorder: true,
              onTap: () => _navigateTo(
                    context,
                    () => Get.off(() => StatsView(),
                        transition: Transition.rightToLeft,
                        duration: 400.milliseconds,
                        curve: Curves.easeIn),
                  ),
            ),
            const Spacer(),
            Obx(() {
              final auth = FirebaseAuthService.to;
              return _navigationTile(
                iconHeight: screenWidth * 0.06,
                iconWidth: screenWidth * 0.06,
                title: auth.isLoggedIn ? 'Sign Out' : 'Sign In',
                icon: avatarIcon,
                showBorder: false,
                onTap: () async {
                  if (auth.isLoggedIn) {
                    await auth.signOut();
                  } else {
                    Get.back();
                    FirebaseLoginSheet.show(context);
                  }
                },
              );
            }),
            SizedBox(
              height: screenHeight * 0.04,
            ),
          ],
        ));
  }

  void _navigateTo(BuildContext context, VoidCallback navigate) {
    final home = Get.find<HomeController>();
    if (home.isLocked && !home.isPaused) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Timer is running'),
          content: const Text(
              'The timer is still running. Are you sure you want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                home.resetTimer();
                navigate();
              },
              child: const Text('Leave'),
            ),
          ],
        ),
      );
    } else {
      navigate();
    }
  }

  _navigationTile(
      {required double iconHeight,
      required double iconWidth,
      required String title,
      String? icon,
      IconData? materialIcon,
      bool showBorder = true,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.62,
        height: screenWidth * 0.1,
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors().lightGrey,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Container(
          margin: EdgeInsets.only(
            bottom: screenWidth * 0.03,
            left: screenWidth * 0.025,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              materialIcon != null
                  ? Icon(
                      materialIcon,
                      size: iconWidth,
                      color: AppColors().secondary,
                    )
                  : SvgPicture.asset(
                      icon!,
                      width: iconHeight,
                      height: iconWidth,
                      colorFilter: ColorFilter.mode(
                        AppColors().secondary,
                        BlendMode.srcIn,
                      ),
                    ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              CustomText(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors().secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
