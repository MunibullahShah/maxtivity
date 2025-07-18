import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/login/widgets/password_visibility.dart';
import 'package:maxtivity/modules/sign_up/view/signup_view.dart';
import 'package:maxtivity/utils/ui/buttons/primary_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:maxtivity/utils/ui/drawer/custom_drawer.dart';
import 'package:maxtivity/utils/ui/textfields/custom_textfield.dart';

const String loginRoute = '/login';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // setStatusBarIconsColor(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.09),
              CustomText(
                text: 'Log In',
                fontSize: 32,
                color: AppColors().darkActive,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text: 'Enter your details below to login',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors().greyText,
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                child: CustomTextField(
                  validationFunction: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: SvgPicture.asset(mobileIcon),
                  ),
                  controller: emailController,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                validationFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                maxLines: 1,
                hintText: 'Enter your Password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: SvgPicture.asset(lockIcon),
                ),
                controller: passwordController,
              ),
              SizedBox(height: screenHeight * 0.02),
              // InkWell(
              //   splashColor: AppColors().transparent,
              //   highlightColor: AppColors().transparent,
              //   onTap: () {
              //     // Get.to(const RetrievePassword());
              //   },
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: CustomText(
              //       text: 'Forget password?',
              //       fontSize: 8,
              //       fontWeight: FontWeight.w700,
              //       color: AppColors().secondary,
              //     ),
              //   ),
              // ),
              SizedBox(height: screenHeight * 0.02),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Don't have an account?",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors().greyText,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    InkWell(
                      splashColor: AppColors().transparent,
                      highlightColor: AppColors().transparent,
                      onTap: () {},
                      child: CustomText(
                        text: "Create now",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.069,
                margin: EdgeInsets.only(
                  left: screenWidth * 0.01,
                  right: screenWidth * 0.01,
                  bottom: screenHeight * 0.02,
                ),
                child: PrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  text: 'Log In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
