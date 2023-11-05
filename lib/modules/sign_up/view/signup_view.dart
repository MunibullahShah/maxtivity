import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/login/view/login_view.dart';
import 'package:maxtivity/modules/login/widgets/password_visibility.dart';
import 'package:maxtivity/modules/sign_up/controller/signup_controller.dart';
import 'package:maxtivity/utils/ui/buttons/primary_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:maxtivity/utils/ui/textfields/custom_textfield.dart';

const String signUpRoute = '/signUp';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(builder: (logic) {
      return Scaffold(
        body: Form(
          key: _formKey,
          child: SafeArea(
              child: signUpController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: screenHeight * 0.06,
                          left: screenWidth * 0.03,
                          right: screenWidth * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildSignUpText(),
                          buildSignUpFreeMessage(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildNameField(),
                              buildEmailField(),
                              buildPasswordField(),
                            ],
                          ),
                          buildLoginOption(),
                          buildSubmitButton(),
                        ],
                      ),
                    )),
        ),
      );
    });
  }

  Widget buildSignUpText() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.05),
        child: CustomText(
          text: "Sign Up",
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildSignUpFreeMessage() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.001),
        child: CustomText(
          color: AppColors().greyText,
          text: "Enter your details below & free sign up",
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.02),
      child: CustomTextField(
        validationFunction: (value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          }
        },
        hintText: 'Enter your Name',
        prefixIcon: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SvgPicture.asset(
            avatarIcon,
            height: screenHeight * 0.01,
          ),
        ),
        controller: signUpController.nameController,
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.02),
      child: CustomTextField(
        keyboardType: TextInputType.phone,
        validationFunction: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email';
          } else if (!GetUtils.isEmail(value)) {
            return 'Please enter a valid email';
          }
        },
        hintText: 'Enter your email',
        prefixIcon: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SvgPicture.asset(
            mobileIcon,
          ),
        ),
        controller: signUpController.emailController,
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.02),
        child: Obx(
          () => CustomTextField(
            validationFunction: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
            },
            obscureText: signUpController.obscurePassword.value,
            suffixIcon: PasswordVisibility(
              obscurePassword: signUpController.obscurePassword.value,
              onTap: signUpController.hidePassword,
            ),
            hintText: 'Enter your Password',
            maxLines: 1,
            prefixIcon: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: SvgPicture.asset(
                lockIcon,
              ),
            ),
            controller: signUpController.passwordController,
          ),
        ));
  }

  Widget buildLoginOption() {
    return Container(
      margin: EdgeInsets.only(
          bottom: screenHeight * 0.02, top: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: "Already a member?",
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors().greyText,
          ),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          InkWell(
            onTap: () {
              Get.to(() => LoginView(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeIn);
            },
            child: CustomText(
              text: "Login",
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    return Obx(() {
      return signUpController.isLoading.value
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                color: AppColors().secondary,
              ),
            )
          : Container(
              height: 50,
              margin: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.03,
                  bottom: screenHeight * 0.02),
              child: PrimaryButton(
                text: "Sign Up",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signUpController.signUp();
                  }
                },
              ),
            );
    });
  }
}
