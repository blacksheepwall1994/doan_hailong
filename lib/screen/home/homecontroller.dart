import 'dart:async';
import 'dart:math';

import 'package:doan_along/util/mqtt.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:progress_state_button/progress_button.dart';

class HomeController extends GetxController {
  final client = MqttServerClient('broker.mqttdashboard.com', '');

  RxBool systemStatus = true.obs;
  RxInt graph = 0.obs;
  RxDouble test = 4.0.obs;
  Rx<ButtonState> stateTextWithIconMinWidthState = ButtonState.idle.obs;

  RxList<double> solarData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  RxList<double> inputCurrData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  RxList<double> lithiumData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  RxList<double> outputCurrData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  RxList<double> inputWatData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  RxList<double> outputWatData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;

  RxList<String> type = [
    'Solar battery voltage',
    'Input electric current',
    'Lithium battery voltage',
    'Output electric current',
    'Input wattage',
    'Output wattage',
    'Duty cycle'
  ].obs;
  List<String> unit = ['V', 'A', 'V', 'A', 'W', 'W'];
  RxList<String> yValue = [
    DateFormat('HH:mm:ss')
        .format(DateTime.now().subtract(const Duration(seconds: 15))),
    DateFormat('HH:mm:ss')
        .format(DateTime.now().subtract(const Duration(seconds: 12))),
    DateFormat('HH:mm:ss')
        .format(DateTime.now().subtract(const Duration(seconds: 9))),
    DateFormat('HH:mm:ss')
        .format(DateTime.now().subtract(const Duration(seconds: 6))),
    DateFormat('HH:mm:ss')
        .format(DateTime.now().subtract(const Duration(seconds: 3))),
    DateFormat('HH:mm:ss').format(DateTime.now())
  ].obs;
  // List solar = ['0V', '5.5V', '11V', '16.5V', '22V'];
  // List inputcurr = ['0A', '1A', '2A', '3A', '4A'];

  late Timer timer;
  List allData = [
    [0, 22],
    [0, 4],
    [0, 14.4],
    [0, 5],
    [0, 50],
    [0, 50]
  ];
  @override
  void onInit() async {
    // TODO: implement onInit
    await initMqtt();
    super.onInit();
    // print(yValue);
    // timer = Timer.periodic(const Duration(minutes: 5), (timer) {
    //   yValue.value = [
    //     DateFormat('HH:mm:ss')
    //         .format(DateTime.now().subtract(const Duration(minutes: 25))),
    //     DateFormat('HH:mm:ss')
    //         .format(DateTime.now().subtract(const Duration(minutes: 20))),
    //     DateFormat('HH:mm:ss')
    //         .format(DateTime.now().subtract(const Duration(minutes: 15))),
    //     DateFormat('HH:mm:ss')
    //         .format(DateTime.now().subtract(const Duration(minutes: 10))),
    //     DateFormat('HH:mm:ss')
    //         .format(DateTime.now().subtract(const Duration(minutes: 5))),
    //     DateFormat('HH:mm:ss').format(DateTime.now())
    //   ];
    // });
  }

  Future initMqtt() async {
    // TODO: implement onInit
    super.onInit();
    client.logging(on: true);
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('${DateTime.now()}')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMess;
    await client.connect('emqx', 'public');
    client.subscribe('mqtt_along', MqttQos.exactlyOnce);
  }

  Widget generateY(double x, int index) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    var min = allData[index][0];
    var max = allData[index][1];
    double step = double.parse(((max - min) / 4).toStringAsFixed(2));
    // print('$min, $max , $step');
    String text;
    switch (x.toInt()) {
      case 0:
        text = '$min ${unit[index]}';
        break;
      case 1:
        text = '${min + step * 1} ${unit[index]}';
        break;
      case 2:
        text = '${min + step * 2} ${unit[index]}';
        break;
      case 3:
        text = '${min + step * 3} ${unit[index]}';
        break;
      case 4:
        // print('$min, $max , $step');
        text = '${min + step * 4} ${unit[index]}';
        break;
      default:
        return Container();
    }
    // print(text);
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  List<FlSpot> spot(int x) {
    var min = allData[x][0];
    var max = allData[x][1];

    double step = double.parse(((max - min) / 4).toStringAsFixed(2));

    List dataL = [];
    x == 0
        ? dataL = solarData
        : x == 1
            ? dataL = inputCurrData
            : x == 2
                ? dataL = lithiumData
                : x == 3
                    ? dataL = outputCurrData
                    : x == 4
                        ? dataL = inputWatData
                        : dataL = outputWatData;
    List<FlSpot> list = [];

    for (int i = 0; i < dataL.length; i++) {
      list.add(
        FlSpot(double.parse('${i * 2}'), dataL[i] / step),
      );
    }
    // print(list);
    return list;
  }

  void updateData(Map data, DateTime updateTime) {
    // print(solarData);
    solarData.removeAt(0);
    inputCurrData.removeAt(0);
    lithiumData.removeAt(0);
    outputCurrData.removeAt(0);
    inputWatData.removeAt(0);
    outputWatData.removeAt(0);

    // solarData.add(double.parse(data[type[0]]));
    // inputCurrData.add(double.parse(data[type[1]]));
    // lithiumData.add(double.parse(data[type[2]]));
    // outputCurrData.add(double.parse(data[type[3]]));
    // inputWatData.add(double.parse(data[type[4]]));
    // outputWatData.add(double.parse(data[type[5]]));

    solarData.add(data[type[0]]);
    inputCurrData.add(data[type[1]]);
    lithiumData.add(data[type[2]]);
    outputCurrData.add(data[type[3]]);
    inputWatData.add(data[type[4]]);
    outputWatData.add(data[type[5]]);

    yValue.value = [
      DateFormat('HH:mm:ss')
          .format(updateTime.subtract(const Duration(seconds: 15))),
      DateFormat('HH:mm:ss')
          .format(updateTime.subtract(const Duration(seconds: 12))),
      DateFormat('HH:mm:ss')
          .format(updateTime.subtract(const Duration(seconds: 9))),
      DateFormat('HH:mm:ss')
          .format(updateTime.subtract(const Duration(seconds: 6))),
      DateFormat('HH:mm:ss')
          .format(updateTime.subtract(const Duration(seconds: 3))),
      DateFormat('HH:mm:ss').format(DateTime.now())
    ];
  }

  String customRound(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod).toStringAsFixed(places);
  }

  Future power() async {
    systemStatus.value = !systemStatus.value;
    final builder = MqttClientPayloadBuilder();
    builder.addString(systemStatus.value ? 'ON' : 'OFF');
    client.publishMessage(
        'mqtt_along_send', MqttQos.atMostOnce, builder.payload!);
  }
}
