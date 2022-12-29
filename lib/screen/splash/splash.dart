import 'package:doan_along/screen/splash/splashcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fade(
        child: const Center(
          child: SizedBox(
              height: 100,
              // width: 100,
              child: Text(
                'Chào mừng đến với Solar System B18DCDT131',
                textAlign: TextAlign.center,
              )),
        ),
      ),
    );
  }
}
