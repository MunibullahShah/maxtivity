import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maxtivity/config/theme/app_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:maxtivity/navigation/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  final _appRouter = MaxtivityRouter();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'Maxtivity',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().appLightTheme,
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
