import 'dart:convert';

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:doan_along/screen/home/homecontroller.dart';
import 'package:doan_along/util/constain.dart';
import 'package:doan_along/util/drawer.dart';
import 'package:doan_along/util/mqtt.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map data = {};
    // MqttBroker mqttBroker = Get.find<MqttBroker>();

    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
                stream: controller.client.updates!.asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        children: const [
                          Text('Đang kết nối đến MQTT, vui lòng chờ'),
                          SizedBox(height: 20),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final recMess =
                        snapshot.data![0].payload as MqttPublishMessage;
                    final pt = MqttPublishPayload.bytesToStringAsString(
                        recMess.payload.message);
                    try {
                      data = jsonDecode(pt);
                    } catch (e) {
                      data = {
                        "Solar battery voltage": 10.0,
                        "Input electric current": 0.1,
                        "Lithium battery voltage": 10.2,
                        "Output electric current": 0.3,
                        "Input wattage": 0.9,
                        "Output wattage": 2.65,
                        "Duty cycle": 75
                      };
                    }
                    controller.updateData(data, DateTime.now());

                    return Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                const Text('Solar panel'),
                                CircularSeekBar(
                                  height: 150,
                                  width: 150,
                                  progress: 70,
                                  strokeCap: StrokeCap.round,
                                  barWidth: 10,
                                  startAngle: 45,
                                  sweepAngle: 270,
                                  progressColor: Colors.green.shade300,
                                  child: Center(
                                      child: Text(
                                    '${controller.customRound(data['Input wattage'], 3)}W',
                                    style: const TextStyle(fontSize: 24),
                                  )),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                const Text('Battery percentage'),
                                CircularSeekBar(
                                  progress: ((data['Lithium battery voltage'] -
                                                  8) /
                                              6.4 *
                                              100) <=
                                          0
                                      ? 0
                                      : ((data['Lithium battery voltage'] - 8) /
                                          6.4 *
                                          100),
                                  height: 150,
                                  width: 150,
                                  strokeCap: StrokeCap.round,
                                  barWidth: 10,
                                  startAngle: 45,
                                  sweepAngle: 270,
                                  progressColor: Colors.green.shade300,
                                  child: Center(
                                      child: Text(
                                    '${(((data['Lithium battery voltage'] - 8) / 6.4 * 100).round()) < 0 ? 0 : ((data['Lithium battery voltage'] - 8) / 6.4 * 100).round()}%',
                                    style: const TextStyle(fontSize: 24),
                                  )),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.22,
                          width: Get.width,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                            ),
                            itemBuilder: (context, index) => Column(
                              children: [
                                Text(
                                  index != 4
                                      ? controller.type[index]
                                      : 'Perfomance',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  index != 4
                                      ? '${controller.customRound(data[controller.type[index]], 3)} ${controller.unit[index]}'
                                      : controller.customRound(
                                          (data[controller.type[5]] /
                                                  data[controller.type[4]]) *
                                              100,
                                          0),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: LinearPercentIndicator(
                            percent: data[controller.type[6]] / 100,
                            trailing: Text('${data[controller.type[6]]} %'),
                            progressColor: Colors.green,
                            leading: const Text('Duty cycle'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => DropdownButton(
                              value: controller.graph.value,
                              focusColor: Colors.red,
                              selectedItemBuilder: (context) => const [
                                Text(
                                  'Solar voltage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Input electric current',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Lithium battery voltage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Output electric current',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Input wattage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Output wattage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                              items: const [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text(
                                    'Solar voltage',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Input electric current',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text(
                                    'Lithium battery voltage',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text(
                                    'Output electric current',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 4,
                                  child: Text(
                                    'Input wattage',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 5,
                                  child: Text(
                                    'Output wattage',
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                controller.graph.value = value as int;
                                print(controller.graph.value);
                              },
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => SizedBox(
                            height: Get.height * 0.3,
                            width: Get.width,
                            child: LineChart(
                              LineChartData(
                                lineTouchData: LineTouchData(enabled: false),
                                gridData: FlGridData(
                                  //khong nghi duoc gi het, cuu
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: 1,
                                  verticalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xff37434d),
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xff37434d),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          const style = TextStyle(
                                            color: Color(0xff68737d),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          );
                                          Widget text;

                                          switch (value.toInt()) {
                                            case 0:
                                              text = Text(
                                                  controller.yValue[0]
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: style);
                                              break;
                                            case 2:
                                              text = Text(
                                                  controller.yValue[1]
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: style);
                                              break;
                                            case 4:
                                              text = Text(
                                                  controller.yValue[2]
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: style);
                                              break;
                                            case 6:
                                              text = Text(
                                                  controller.yValue[3]
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: style);
                                              break;
                                            case 8:
                                              text = Text(
                                                  controller.yValue[4]
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: style);
                                              break;
                                            case 10:
                                              text = Text(
                                                  controller.yValue[5]
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: style);
                                              break;
                                            default:
                                              text =
                                                  const Text('', style: style);
                                              break;
                                          }

                                          return SideTitleWidget(
                                            space: 2,
                                            axisSide: meta.axisSide,
                                            child: SizedBox(
                                                height: 100,
                                                width: 70,
                                                child: text),
                                          );
                                        }),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      reservedSize: 42,
                                      getTitlesWidget: (value, meta) {
                                        int index = controller.graph.value;
                                        return controller.generateY(
                                            value, index);
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: const Color(0xff37434d)),
                                ),
                                minX: 0,
                                maxX: 10,
                                minY: 0,
                                maxY: controller.graph.value <= 6 ? 4 : 1000,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots:
                                        controller.spot(controller.graph.value),
                                    isCurved: true,
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                    ),
                                    barWidth: 5,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: gradientColors
                                            .map((color) =>
                                                color.withOpacity(0.3))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('Waiting for data to download'),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(),
                        // Text('${snapshot.connectionState}'),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
