import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetable/app/data/slot.dart';

class WeeklyController extends GetxController {
  final scrollController = ScrollController();
  final firstPositionY = 20.0;
  double fingerOffset = 0.0;
  Slot? draggedSlot;

  final slots = <Slot>[].obs;

  // TODO: can be removed
  bool collisions(Slot slot, List<Slot> slots) {
    for (final other in slots) {
      if (slot.day != other.day) continue;
      final s = formatHHmm.parse(slot.start);
      final o = formatHHmm.parse(other.start);
      if (s.difference(o).inMinutes.abs() < 45) return true;
    }
    return false;
  }
}
