import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetable/app/data/slot.dart';

class DailyController extends GetxController {
  final scrollController = ScrollController();
  final firstPositionY = 0.0;
  double fingerOffset = 0.0;
  Slot? draggedSlot;

  final slots = <Slot>[].obs;

  int doubleSlotIndex(Slot slot) {
    for (final other in slots) {
      if (slot.start == other.end) return 0;
      if (slot.end == other.start) return 1;
    }
    return -1;
  }

  int _chainLength(Slot slot, List<Slot> slots) {
    slots.remove(slot);
    for (final other in slots) {
      if (slot.start == other.end || slot.end == other.start) {
        return _chainLength(other, slots) + 1;
      }
    }
    return 1;
  }

  Object collisions(Slot slot, List<Slot> slots) {
    for (final other in slots) {
      final s = formatHHmm.parse(slot.start);
      final o = formatHHmm.parse(other.start);
      if (s.difference(o).inMinutes.abs() < 45) return other;
    }
    if (_chainLength(slot, slots.toList()) >= 3) return true;
    return false;
  }

  void onDrag(DragUpdateDetails details, Slot slot) {
    var newSlot = Slot(
      details.globalPosition.dy -
          fingerOffset -
          fifteenHeight +
          scrollController.offset,
    );
    var collisionStatus = collisions(newSlot, slots.toList()..remove(slot));
    if (collisionStatus is Slot) {
      newSlot = Slot(collisionStatus.position +
          fourtyFiveHeight * (details.delta.dy > 0 ? 1 : -1));
      if (collisions(newSlot, slots.toList()..remove(slot)) != false) return;
    } else if (collisionStatus != false) {
      return;
    }
    slot.position = newSlot.position;
    slot.start = newSlot.start;
    slot.end = newSlot.end;
    slots.refresh();
  }
}
