# UI Components Codemap

**Last Updated:** 2026-04-17

## Overview

Maxtivity provides a comprehensive library of reusable UI components styled with custom colors, typography, and animations. Components are modular and can be composed to build complex screens.

---

## Directory Structure

```
utils/ui/
├── buttons/
│   ├── primary_button.dart
│   ├── secondary_button.dart
│   └── side_bar_button.dart
├── textfields/
│   ├── custom_textfield.dart
│   └── large_textfield.dart
├── dialogs/
│   └── [dialog widgets]
├── drop_down/
│   └── custom_drop_down.dart
├── date_time_widget/
│   └── date_time_widget.dart
├── appbar/
│   └── appBar.dart
├── drawer/
│   └── custom_drawer.dart
├── api_state_widget.dart
├── custom_text.dart
├── error_page.dart
├── grey_box_for_shimmer.dart
├── loader.dart
├── no_internet_page.dart
├── snackbar.dart
├── top_box_child_text.dart
└── ui.dart
```

---

## Core Components

### 1. Buttons

#### PrimaryButton
**File:** `lib/utils/ui/buttons/primary_button.dart`

Primary call-to-action button with rounded corners and shadow.

```dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  
  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.textStyle,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
          elevation: 2,
        ),
        child: isLoading
          ? SizedBox(
            height: 20.sp,
            width: 20.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? Colors.white,
              ),
            ),
          )
          : CustomText(
            label,
            style: textStyle ?? AppTextStyles.buttonText,
            textColor: textColor ?? Colors.white,
          ),
      ),
    );
  }
}
```

**Usage:**
```dart
PrimaryButton(
  label: 'Start Timer',
  onPressed: () => controller.startTimer(),
  isLoading: controller.isLoading,
)
```

#### SecondaryButton
**File:** `lib/utils/ui/buttons/secondary_button.dart`

Outlined button for secondary actions.

```dart
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.borderColor,
    this.textColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: borderColor ?? AppColors.primaryColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
      ),
      child: CustomText(
        label,
        textColor: textColor ?? AppColors.primaryColor,
      ),
    );
  }
}
```

#### SideBarButton
**File:** `lib/utils/ui/buttons/side_bar_button.dart`

Navigation button for drawer/sidebar menu.

```dart
class SideBarButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  
  const SideBarButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.primaryColor : AppColors.greyText,
      ),
      title: CustomText(
        label,
        textColor: isActive ? AppColors.primaryColor : AppColors.greyText,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
      onTap: onPressed,
      selected: isActive,
      tileColor: isActive
        ? AppColors.primaryColor.withOpacity(0.1)
        : Colors.transparent,
    );
  }
}
```

---

### 2. Text Fields

#### CustomTextField
**File:** `lib/utils/ui/textfields/custom_textfield.dart`

Single-line text input with label, hint, and validation.

```dart
class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final int minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  
  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);
  
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode focusNode;
  
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }
  
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          widget.label,
          style: AppTextStyles.labelText,
        ),
        SizedBox(height: 5.h),
        TextFormField(
          controller: widget.controller,
          focusNode: focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          style: AppTextStyles.bodyText,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(
                color: AppColors.errorColor,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 10.sp,
            ),
          ),
        ),
      ],
    );
  }
}
```

**Usage:**
```dart
CustomTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email required';
    if (!value!.isEmail) return 'Invalid email format';
    return null;
  },
)
```

#### LargeTextField
**File:** `lib/utils/ui/textfields/large_textfield.dart`

Multi-line text input for longer content.

```dart
class LargeTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final int minLines;
  final String? Function(String?)? validator;
  final int? maxCharacters;
  
  const LargeTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 5,
    this.minLines = 3,
    this.validator,
    this.maxCharacters,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: AppTextStyles.labelText),
        SizedBox(height: 5.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxCharacters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

### 3. Custom Text Component

**File:** `lib/utils/ui/custom_text.dart`

Unified text component with consistent styling.

```dart
class CustomText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final bool hasUnderline;
  final String? fontFamily;
  
  const CustomText(
    this.text, {
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.hasUnderline = false,
    this.fontFamily,
  });
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
        color: textColor ?? style?.color ?? AppColors.textBlack,
        fontSize: fontSize ?? style?.fontSize,
        fontWeight: fontWeight ?? style?.fontWeight,
        fontFamily: fontFamily ?? style?.fontFamily,
        decoration: hasUnderline ? TextDecoration.underline : null,
      ) ?? TextStyle(
        color: textColor ?? AppColors.textBlack,
        fontSize: fontSize ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: fontFamily,
        decoration: hasUnderline ? TextDecoration.underline : null,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
```

**Usage:**
```dart
CustomText(
  'Session Duration',
  style: AppTextStyles.heading1,
  textColor: AppColors.primaryColor,
  textAlign: TextAlign.center,
)
```

---

### 4. Dropdown Component

**File:** `lib/utils/ui/drop_down/custom_drop_down.dart`

Custom dropdown with icon and styling.

```dart
class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T?) onChanged;
  final Color? backgroundColor;
  
  const CustomDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: DropdownButton<T>(
        value: value,
        hint: CustomText(label),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: CustomText(itemLabel(item)),
          );
        }).toList(),
        onChanged: onChanged,
        underline: SizedBox.shrink(),
        isExpanded: true,
      ),
    );
  }
}
```

**Usage:**
```dart
CustomDropdown<int>(
  label: 'Select Duration',
  value: selectedIndex,
  items: List.generate(homeController.timeOptions.length, (i) => i),
  itemLabel: (index) => homeController.timeOptions[index]['label'],
  onChanged: (index) => homeController.selectTimeOption(index ?? 0),
)
```

---

### 5. Dialog Widgets

**File:** `lib/utils/ui/dialogs/`

Common dialog patterns.

```dart
// Confirmation dialog
showConfirmationDialog(
  context,
  title: 'Delete Session?',
  message: 'This action cannot be undone.',
  confirmLabel: 'Delete',
  cancelLabel: 'Cancel',
  onConfirm: () => deleteSession(),
)

// Loading dialog
showLoadingDialog(context, message: 'Please wait...')

// Info dialog
showInfoDialog(
  context,
  title: 'Session Completed',
  message: 'Great job! You completed 25 minutes.',
)
```

---

### 6. Drawer Navigation

**File:** `lib/utils/ui/drawer/custom_drawer.dart`

Navigation drawer with user profile and menu items.

```dart
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30.sp,
                  backgroundImage: NetworkImage(userModel.profileImage),
                ),
                SizedBox(height: 10.h),
                CustomText(
                  userModel.fullName,
                  style: AppTextStyles.heading2,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          SideBarButton(
            label: 'Home',
            icon: Icons.home,
            onPressed: () => Get.back(),
          ),
          SideBarButton(
            label: 'History',
            icon: Icons.history,
            onPressed: () => Get.toNamed('/history'),
          ),
          SideBarButton(
            label: 'Settings',
            icon: Icons.settings,
            onPressed: () => Get.toNamed('/settings'),
          ),
          Divider(),
          SideBarButton(
            label: 'Logout',
            icon: Icons.logout,
            onPressed: () => handleLogout(),
          ),
        ],
      ),
    );
  }
}
```

---

### 7. State Indicators

#### Loader
**File:** `lib/utils/ui/loader.dart`

Centered loading spinner with animation.

```dart
class Loader extends StatelessWidget {
  final String? message;
  final Color? color;
  
  const Loader({this.message, this.color});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AssetPaths.loaderAnimation,
            height: 80.h,
          ),
          if (message != null) ...[
            SizedBox(height: 15.h),
            CustomText(message!),
          ],
        ],
      ),
    );
  }
}
```

#### Shimmer Loader
**File:** `lib/utils/ui/grey_box_for_shimmer.dart`

Skeleton loading placeholder.

```dart
class GreyBoxForShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  
  const GreyBoxForShimmer({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
```

---

### 8. Error States

#### ErrorPage
**File:** `lib/utils/ui/error_page.dart`

Full-screen error display.

```dart
class ErrorPage extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  
  const ErrorPage({
    required this.message,
    this.title,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 60.sp, color: AppColors.errorColor),
            SizedBox(height: 16.h),
            CustomText(
              title ?? 'Error',
              style: AppTextStyles.heading1,
              textColor: AppColors.errorColor,
            ),
            SizedBox(height: 8.h),
            CustomText(message, textAlign: TextAlign.center),
            SizedBox(height: 20.h),
            if (onRetry != null)
              PrimaryButton(
                label: 'Retry',
                onPressed: onRetry!,
              ),
          ],
        ),
      ),
    );
  }
}
```

#### NoInternetPage
**File:** `lib/utils/ui/no_internet_page.dart`

Offline state display.

```dart
class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 60.sp,
              color: AppColors.greyText,
            ),
            SizedBox(height: 16.h),
            CustomText(
              'No Internet Connection',
              style: AppTextStyles.heading1,
            ),
            SizedBox(height: 8.h),
            CustomText(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 9. Snackbar Notifications

**File:** `lib/utils/ui/snackbar.dart`

Toast-like notifications.

```dart
class ShowSnackBar {
  static void show({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    Get.snackbar(
      'Notification',
      message,
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      colorText: textColor ?? Colors.white,
      duration: duration,
      snackPosition: position == SnackBarPosition.top
        ? SnackPosition.TOP
        : SnackPosition.BOTTOM,
      margin: EdgeInsets.all(12.sp),
      borderRadius: 12.sp,
    );
  }
  
  static void showSuccess({required String message}) {
    show(
      message: message,
      backgroundColor: Colors.green,
    );
  }
  
  static void showError({required String message}) {
    show(
      message: message,
      backgroundColor: AppColors.errorColor,
    );
  }
}
```

**Usage:**
```dart
ShowSnackBar.show(message: 'Session saved!');
ShowSnackBar.showSuccess(message: 'Operation completed');
ShowSnackBar.showError(message: 'Something went wrong');
```

---

### 10. Date/Time Widget

**File:** `lib/utils/ui/date_time_widget/date_time_widget.dart`

Display and select date/time.

```dart
class DateTimeWidget extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onTap;
  final String format; // 'date', 'time', 'datetime'
  
  const DateTimeWidget({
    required this.dateTime,
    required this.onTap,
    this.format = 'datetime',
  });
  
  @override
  Widget build(BuildContext context) {
    String displayText;
    
    if (format == 'date') {
      displayText = DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (format == 'time') {
      displayText = DateFormat('HH:mm').format(dateTime);
    } else {
      displayText = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(displayText),
            Icon(Icons.calendar_today, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
```

---

## Component Usage Examples

### Complete Form Screen

```dart
class LoginView extends StatelessWidget {
  final controller = Get.put(LoginController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Email',
                hint: 'Enter email',
                controller: emailController,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: 'Password',
                hint: 'Enter password',
                controller: passwordController,
                obscureText: true,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 20.h),
              GetBuilder<LoginController>(
                builder: (_) => PrimaryButton(
                  label: 'Login',
                  onPressed: () => controller.login(
                    emailController.text,
                    passwordController.text,
                  ),
                  isLoading: controller.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Styling Reference

### Colors
See [app_colors.dart](../config/theme/app_colors.dart)

### Typography
See [app_text_styles.dart](../config/theme/app_text_styles.dart)

### Responsive Sizing
Uses `Sizer` package:
- `.w` for width (% of screen)
- `.h` for height (% of screen)
- `.sp` for font size (responsive)

---

See also:
- [APP_ARCHITECTURE.md](../CODEMAPS/APP_ARCHITECTURE.md)
- [MODULES.md](../CODEMAPS/MODULES.md) for screen examples
