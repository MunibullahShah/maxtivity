import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maxtivity/config/theme/app_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:maxtivity/navigation/app_router.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: MyApp()));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // GoRouter instance is provided by Riverpod

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'Maxtivity',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().appLightTheme,
          routerConfig: ref.watch(goRouterProvider),
        );
      },
    );
  }
}
