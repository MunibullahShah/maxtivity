import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double? width;
  final Function onTap;
  var color;
  var textColor;
  double? fontSize;
  var fontWeight;
  final String? icon;

  BorderRadius? borderRadius;
  BorderSide? side;

  Color? borderColor;

  PrimaryButton({
    Key? key,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.side,
    this.borderRadius,
    required this.text,
    this.width,
    required this.onTap,
    this.color,
    this.borderColor,
    this.icon = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap.call();
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(screenWidth * .02),
          side:
              side ?? BorderSide(color: borderColor ?? AppColors().transparent),
        )),
        backgroundColor:
            MaterialStateProperty.all(color ?? AppColors().secondary),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(width ?? double.infinity, 0.07 * screenHeight),
        ),
        maximumSize: MaterialStateProperty.all<Size>(
          Size(width ?? double.infinity, 0.4 * screenHeight),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            icon == null ? MainAxisAlignment.center : MainAxisAlignment.center,
        children: [
          icon == ''
              ? Container(
                  height: 0,
                  width: 0,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    icon ?? "",
                    color: textColor ?? AppColors().primary,
                  ),
                ),
          CustomText(
            color: textColor ?? AppColors().primary,
            text: text,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
