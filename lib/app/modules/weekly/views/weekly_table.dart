import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timetable/app/data/slot.dart';
import 'package:timetable/app/modules/weekly/controllers/weekly_controller.dart';

class WeeklyTable extends StatelessWidget {
  const WeeklyTable(this.controller, {super.key});

  final WeeklyController controller;

  static const timesWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    final slotWidth = (Get.width - timesWidth) / 7;
    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Obx(
        () => Stack(
          children: [
            _buildBackground(DateTime(0), slotWidth),
            for (final slot in controller.slots) _buildSlot(slot, slotWidth),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBackground(DateTime initial, double slotWidth) {
    // TODO remove gesture detector
    return GestureDetector(
      onTapDown: (details) {
        final day =
            ((details.globalPosition.dx - timesWidth) / slotWidth).floor();
        if (day < 0) return;
        final slot = Slot(
          details.globalPosition.dy +
              controller.scrollController.offset -
              fifteenHeight -
              controller.firstPositionY,
          day: day,
        );
        if (controller.collisions(slot, controller.slots)) return;
        controller.slots.add(slot);
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: controller.firstPositionY + fifteenHeight / 2,
            ),
            child: Column(
              children: [
                for (int i = 0; i < 96; i++)
                  SizedBox(
                    width: timesWidth,
                    height: fifteenHeight,
                    child: Text(
                      formatHHmm.format(initial.add(Duration(minutes: 15 * i))),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: controller.firstPositionY,
                  child: Row(
                    children: [
                      for (int i = 0; i < 7; i++)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: const BorderSide(color: Colors.grey),
                                bottom: const BorderSide(color: Colors.grey),
                                left: i == 0
                                    ? const BorderSide(color: Colors.grey)
                                    : BorderSide.none,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                i.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                for (int i = 0; i < 96 + 1; i++)
                  Container(
                    color: Colors.transparent,
                    height: fifteenHeight,
                    child: Row(
                      children: [
                        for (int j = 0; j < 7; j++)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: const BorderSide(color: Colors.grey),
                                  bottom: const BorderSide(color: Colors.grey),
                                  left: j == 0
                                      ? const BorderSide(color: Colors.grey)
                                      : BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(Slot slot, double slotWidth) {
    return Container(
      transform: Matrix4.identity()
        ..setTranslationRaw(0,
            controller.firstPositionY + fifteenHeight / 2 + slot.position, 0),
      margin: EdgeInsets.only(left: timesWidth + slotWidth * slot.day),
      width: slotWidth,
      height: fourtyFiveHeight,
      color: Colors.green,
      child: Text(slot.text),
    );
  }
}
