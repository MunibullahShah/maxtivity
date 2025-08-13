import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/history/view/history_view.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/login/view/login_view.dart';
import 'package:maxtivity/utils/ui/buttons/side_bar_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:sizer/sizer.dart';

import '../../../config/theme/app_colors.dart';
import '../../services/local_storage_service.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

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
                onTap: () {
                  Get.off(() => HomeView(),
                      transition: Transition.rightToLeft,
                      duration: 800.milliseconds,
                      curve: Curves.easeIn);
                }),
            SizedBox(
              height: screenHeight * 0.018,
            ),
            _navigationTile(
              iconHeight: screenWidth * 0.06,
              iconWidth: screenWidth * 0.06,
              title: "History",
              icon: historyIconf,
              showBorder: true,
              onTap: () {
                Get.off(() => HistoryView(),
                    transition: Transition.rightToLeft,
                    duration: 800.milliseconds,
                    curve: Curves.easeIn);
              },
            ),
            const Spacer(),
            _drawerLogoutItem(),
            SizedBox(
              height: screenHeight * 0.04,
            ),
          ],
        ));
  }

  _navigationTile(
      {required double iconHeight,
      required double iconWidth,
      required String title,
      required String icon,
      bool? showDropDown,
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
              SvgPicture.asset(
                icon,
                width: iconHeight,
                height: iconWidth,
                color: AppColors().secondary,
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

  Widget _drawerLogoutItem() {
    return InkWell(
      onTap: () async {
        await LocalStorageService().deleteAll();
        Get.offAll(() => LoginView());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        height: 7.h,
        width: screenWidth * 0.75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              logoutIcon,
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
            ),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            CustomText(
              text: 'Logout'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors().red,
            ),
          ],
        ),
      ),
    );
  }
}
