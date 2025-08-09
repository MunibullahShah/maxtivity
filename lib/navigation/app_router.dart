import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../modules/splash/view/splash_screen.dart';
import '../modules/login/view/login_view.dart';
import '../modules/sign_up/view/signup_view.dart';
import '../modules/home/view/home_view.dart';
import '../modules/auth/auth_provider.dart';

enum AppRoute { splash, login, signup, home }

extension AppRouteExt on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.login:
        return '/login';
      case AppRoute.signup:
        return '/signup';
      case AppRoute.home:
        return '/home';
    }
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: AppRoute.signup.path,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        builder: (context, state) => HomeView(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState is AuthStateAuthenticated;
      final loggingIn =
          state.uri.path == AppRoute.login.path ||
          state.uri.path == AppRoute.signup.path;

      if (!isLoggedIn && !loggingIn) return AppRoute.login.path;
      if (isLoggedIn && loggingIn) return AppRoute.home.path;
      return null;
    },
  );
});
