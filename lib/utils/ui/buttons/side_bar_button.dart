import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:maxtivity/constants/app_constants.dart';

class SidebarButton extends StatelessWidget {
  const SidebarButton({
    required this.sidebarIcon,
    required this.onTap,
    this.isBack = false,
    super.key,
  });

  final String sidebarIcon;
  final Function() onTap;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenWidth * 0.13,
        width: screenWidth * 0.13,
        padding: EdgeInsets.all(screenWidth * 0.037),
        decoration: BoxDecoration(
          color: AppColors().primary,
          borderRadius: BorderRadius.circular(screenWidth * 0.14),
          border: Border.all(
            color: isBack ? AppColors().lightGrey : AppColors().secondary,
            width: 1,
          ),
        ),
        child: SvgPicture.asset(
          sidebarIcon,
          color: AppColors().secondary,
        ),
      ),
    );
  }
}
