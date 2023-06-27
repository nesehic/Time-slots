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
          child: Obx(
            () => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 96; i++)
                      _buildTime(initial.add(Duration(minutes: 15 * i))),
                  ],
                ),
                for (final slot in controller.slots)
                  Container(
                    transform: Matrix4.identity()
                      ..setTranslationRaw(
                        0.0,
                        controller.firstPositionY + slot.position,
                        0.0,
                      ),
                    margin: const EdgeInsets.only(left: 50.0),
                    width: double.infinity,
                    height: fourtyFiveHeight,
                    color: controller.doubleSlotIndex(slot) == -1
                        ? Colors.amber
                        : Colors.blue,
                    child: GestureDetector(
                      onVerticalDragStart: (_) => controller.dragOffset = 0.0,
                      onVerticalDragUpdate: (details) {
                        controller.dragOffset += details.delta.dy;
                        if (controller.dragOffset.abs() < fiveHeight) return;
                        controller.dragSlot(slot);
                        controller.dragOffset = 0.0;
                      },
                      child: SizedBox.expand(child: Text(slot.text)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTime(DateTime time) {
    return GestureDetector(
      onTap: () {
        final times = controller.getTimesFromMiddle(time);
        final slot = Slot(
          controller.getPositionFromTime(times.first),
          formatHHmm.format(times[0]),
          formatHHmm.format(times[1]),
        );
        if (!controller.hasCollision(slot)) controller.slots.add(slot);
      },
      child: Container(
        color: Colors.transparent,
        height: fifteenHeight,
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
