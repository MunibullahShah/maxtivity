import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maxtivity/config/theme/app_theme.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:maxtivity/modules/splash/view/splash_screen.dart';
import 'package:maxtivity/utils/services/object_box.dart';
import 'package:sizer/sizer.dart';

late ObjectBox objectBox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Maxtivity',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().appLightTheme,
          routes: {
            '/': (context) => SplashPage(),
            homeRoute: (context) => HomeView(),
          },
        );
      },
    );
  }
}
