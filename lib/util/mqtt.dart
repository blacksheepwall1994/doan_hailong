import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttBroker extends GetxController {
  final client = MqttServerClient('broker.mqttdashboard.com', '');
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    client.logging(on: true);
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMess;
    await client.connect('emqx', 'public');
    client.subscribe('mqtt_along', MqttQos.exactlyOnce);
  }
}
