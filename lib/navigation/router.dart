import 'package:auto_route/auto_route.dart';
import 'package:maxtivity/modules/splash/view/splash_screen.dart';
part 'router.gr.dart';

@AutoRouterConfig()
class MaxtivityRouter extends RootStackRouter {
  MaxtivityRouter();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
  ];
}
