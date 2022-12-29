import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    await initState();
  }

  Future<void> initState() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed('/home');
  }
}
