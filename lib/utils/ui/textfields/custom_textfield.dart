import 'package:flutter/material.dart';
import 'package:maxtivity/constants/app_constants.dart';

import '../../../config/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? hintText;
  FocusNode? node;
  int? maxLines;
  bool? isCollapsed;

  String? Function(String?)? validationFunction;
  void Function(String)? onChangeFunction;

  CustomTextField({
    Key? key,
    required this.controller,
    this.obscureText,
    this.node,
    this.suffixIcon,
    this.prefixIcon,
    this.validationFunction,
    this.onChangeFunction,
    this.keyboardType,
    this.hintText,
    this.maxLines,
    this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        validator: validationFunction,
        controller: controller,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        obscureText: obscureText ?? false,
        maxLines: maxLines,

        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors().secondary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            fontFamily: 'TenorSans',
            // fontWeight: FontWeight.w500,
            color: AppColors().greyText,
          ),
          enabledBorder: _inputBorder(),
          errorBorder: _inputErrorBorder(),
          focusedBorder: _inputBorder(),
          focusedErrorBorder: _inputErrorBorder(),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          isCollapsed: isCollapsed ?? false,
        ),
        // textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        borderSide: BorderSide(
          width: .5,
          color: AppColors().inputBorderColor,
        ),
      );

  OutlineInputBorder _inputErrorBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        borderSide: BorderSide(
          width: .5,
          color: AppColors().red,
        ),
      );
}
