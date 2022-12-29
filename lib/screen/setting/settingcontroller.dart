import 'package:doan_along/util/mqtt.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  RxBool switch1 = false.obs;
  RxBool switch2 = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Get.put(MqttBroker());
  }
}
