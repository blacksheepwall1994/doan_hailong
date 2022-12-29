import 'package:doan_along/screen/home/homecontroller.dart';
import 'package:doan_along/screen/setting/settingcontroller.dart';
import 'package:doan_along/util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class SettingScreen extends GetView<HomeController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Controller'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text('Tắt hệ thống'),
            Obx(() => InkWell(
                  onTap: () => controller.power(),
                  child: Container(
                    height: Get.height * 0.2,
                    width: Get.height * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: controller.systemStatus.value
                            ? Colors.green
                            : Colors.red,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Icon(
                      Icons.power_settings_new,
                      size: 50,
                      // color: controller.systemStatus.value
                      //     ? Colors.green
                      //     : Colors.red,
                    ),
                  ),
                )),
            // Obx(
            //   () => ProgressButton.icon(
            //     iconedButtons: {
            //       ButtonState.idle: IconedButton(
            //           text: "Turn on/off system",
            //           icon: const Icon(Icons.send, color: Colors.white),
            //           color: Colors.deepPurple.shade500),
            //       ButtonState.loading: IconedButton(
            //           text: "Sending", color: Colors.deepPurple.shade700),
            //       ButtonState.fail: IconedButton(
            //           text: "Failed to send data",
            //           icon: const Icon(Icons.cancel, color: Colors.white),
            //           color: Colors.red.shade300),
            //       ButtonState.success: IconedButton(
            //           text: "Success",
            //           icon: const Icon(
            //             Icons.check_circle,
            //             color: Colors.white,
            //           ),
            //           color: Colors.green.shade400)
            //     },
            //     state: controller.stateTextWithIconMinWidthState.value,
            //     onPressed: () async {
            //       switch (controller.stateTextWithIconMinWidthState.value) {
            //         case ButtonState.idle:
            //           controller.stateTextWithIconMinWidthState.value =
            //               ButtonState.loading;
            //           Future.delayed(Duration(seconds: 1), () {
            //             controller.power();
            //             controller.stateTextWithIconMinWidthState.value =
            //                 ButtonState.success;
            //           });

            //           break;
            //         case ButtonState.loading:
            //           break;
            //         case ButtonState.success:
            //           controller.stateTextWithIconMinWidthState.value =
            //               ButtonState.idle;
            //           break;
            //         case ButtonState.fail:
            //           controller.stateTextWithIconMinWidthState.value =
            //               ButtonState.idle;
            //           break;
            //       }
            //       controller.stateTextWithIconMinWidthState.value =
            //           controller.stateTextWithIconMinWidthState.value;

            //       // Do something
            //       // await Future.delayed(const Duration(seconds: 3));
            //       // Return true to show success state or false to show fail state
            //       return true;
            //     },
            //     // state: ButtonState.loading,
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => Text(controller.systemStatus.value
                ? 'Turn on system'
                : 'Turn off system'))
          ],
        ),
      ),
    );
  }
}
