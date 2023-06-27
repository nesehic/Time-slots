import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final initial = DateTime(0);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 96; i++)
                    _buildTime(initial.add(Duration(minutes: 15 * i))),
                ],
              ),
              Obx(
                () => Container(
                  transform: Matrix4.identity()
                    ..setTranslationRaw(
                      0.0,
                      controller.firstPositionY + controller.position.value,
                      0.0,
                    ),
                  margin: const EdgeInsets.only(left: 50.0),
                  width: double.infinity,
                  height: controller.fourtyFiveHeight,
                  color: Colors.amber,
                  child: Text(controller.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTime(DateTime time) {
    return GestureDetector(
      onTap: () {
        final times = controller.getTimesFromMiddle(time);
        controller.text = times.map((e) => formatHHmm.format(e)).join(' - ');
        controller.position.value = controller.getPositionFromTime(
          times.first,
        );
      },
      child: Container(
        color: Colors.transparent,
        height: controller.fifteenHeight,
        child: Row(
          children: [
            Text(formatHHmm.format(time)),
            const Expanded(child: Divider()),
          ],
        ),
      ),
    );
  }
}
