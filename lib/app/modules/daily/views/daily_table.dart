import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timetable/app/data/slot.dart';
import 'package:timetable/app/modules/daily/controllers/daily_controller.dart';

class DailyTable extends StatelessWidget {
  const DailyTable(this.controller, {super.key});

  final DailyController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Obx(
        () => Stack(
          children: [
            _buildBackground(DateTime(0)),
            _buildSlot(controller.draggedSlot, true),
            for (final slot in controller.slots) _buildSlot(slot),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBackground(DateTime initial) {
    return GestureDetector(
      onTapDown: (details) {
        final slot = Slot(
          details.globalPosition.dy +
              controller.scrollController.offset -
              fifteenHeight,
        );
        if (controller.collisions(slot, controller.slots) != false) return;
        controller.slots.add(slot);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 96; i++)
            Container(
              color: Colors.transparent,
              height: fifteenHeight,
              child: Row(
                children: [
                  Text(formatHHmm.format(
                    initial.add(Duration(minutes: 15 * i)),
                  )),
                  const Expanded(child: Divider()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlot(Slot? slot, [bool isPreview = false]) {
    if (slot == null) return const SizedBox.shrink();

    Color color =
        controller.doubleSlotIndex(slot) == -1 ? Colors.amber : Colors.blue;
    if (isPreview) color = Colors.amber.withAlpha(100);

    return Container(
      transform: Matrix4.identity()
        ..setTranslationRaw(0, controller.firstPositionY + slot.position, 0),
      margin: const EdgeInsets.only(left: 50.0),
      width: double.infinity,
      height: fourtyFiveHeight,
      color: color,
      child: GestureDetector(
        onVerticalDragStart: (details) {
          controller.draggedSlot = Slot(slot.position);
          controller.fingerOffset = details.localPosition.dy;
        },
        onVerticalDragEnd: (_) {
          controller.draggedSlot = null;
          controller.slots.refresh();
        },
        onVerticalDragUpdate: (details) => controller.onDrag(details, slot),
        child: Text(slot.text),
      ),
    );
  }
}
