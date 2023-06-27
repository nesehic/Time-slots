import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // This is 15 minute height.
  static const fifteenHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final initial = DateTime(0);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            controller: controller.scroll,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 96; i++)
                      _buildTime(
                        format.format(initial.add(Duration(minutes: 15 * i))),
                      ),
                  ],
                ),
                Obx(
                  () => Container(
                    transform: Matrix4.identity()
                      ..setTranslationRaw(
                        50.0,
                        controller.position.value.dy,
                        0.0,
                      ),
                    width: 100.0,
                    height: fifteenHeight * 3,
                    color: Colors.amber,
                    child: Text(controller.selectedTime),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTimeFromMiddle(String stime) {
    final time = format.parse(stime);
    final start = time.subtract(const Duration(minutes: 20));
    final end = time.add(const Duration(minutes: 25));
    return '${format.format(start)} - ${format.format(end)}';
  }

  Widget _buildTime(String time) {
    return GestureDetector(
      onTapDown: (details) {
        controller.selectedTime = getTimeFromMiddle(time);
        controller.position.value = details.globalPosition;
        controller.position.value = Offset(
          controller.position.value.dx,
          controller.position.value.dy +
              controller.scroll.position.pixels -
              details.localPosition.dy -
              fifteenHeight,
        );
      },
      child: Container(
        color: Colors.transparent,
        height: fifteenHeight,
        child: Row(
          children: [Text(time), const Expanded(child: Divider())],
        ),
      ),
    );
  }
}
