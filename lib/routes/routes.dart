import 'package:doan_along/screen/credits/credits.dart';
import 'package:doan_along/screen/home/home.dart';
import 'package:doan_along/screen/home/homecontroller.dart';
import 'package:doan_along/screen/setting/setting.dart';
import 'package:doan_along/screen/setting/settingcontroller.dart';
import 'package:doan_along/screen/splash/splash.dart';
import 'package:doan_along/screen/splash/splashcontroller.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const home = '/home';
  static const setting = '/setting';
  static const credits = '/credits';
  static const splash = '/splash';
}

abstract class AppPages {
  static String initial = Routes.splash;
  static final routes = [
    GetPage(
        name: Routes.home,
        page: () => const HomeScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder.put(() => HomeController())),
    GetPage(
        name: Routes.setting,
        page: () => const SettingScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder.put(() => HomeController())),
    GetPage(
        name: Routes.splash,
        page: () => const SplashView(),
        transition: Transition.fade,
        binding: BindingsBuilder.put(() => SplashController())),
    GetPage(
      name: Routes.credits,
      page: () => const CreditsScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder.put(() => HomeController()),
    ),
  ];
}
