import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomText extends StatelessWidget {
  String text;
  int? maxLines;
  TextOverflow? overflow;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  double fontSize;
  TextStyle? style;
  Color? color;
  bool showShadow;
  bool? isTranslateAble;
  double? height;

  CustomText({
    Key? key,
    required this.text,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.fontWeight,
    required this.fontSize,
    this.showShadow = false,
    this.color,
    this.style,
    this.isTranslateAble,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text.tr,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: style ??
          TextStyle(
              height: height,
              fontFamily: 'Poppins',
              fontWeight: fontWeight,
              fontSize: fontSize.sp,
              color: color ?? AppColors().secondary),
    );
  }
}
