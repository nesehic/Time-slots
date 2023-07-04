import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final formatHHmm = DateFormat('HH:mm');

const fifteenHeight = 40.0;
const fiveHeight = fifteenHeight / 3.0;
const fourtyFiveHeight = fifteenHeight * 3.0;
const fullHeight = 96 * fifteenHeight;

class Slot {
  late double position;
  late String start;
  late String end;
  String get text => '$start - $end';

  Slot(double position) {
    final start = _getTimeFromPosition(position);
    this.position = _getPositionFromTime(start);
    this.start = formatHHmm.format(start);
    end = formatHHmm.format(start.add(const Duration(minutes: 45)));
  }

  double _getPositionFromTime(DateTime start) {
    final minutes = start.hour * 60 + start.minute;
    final index = minutes / 5;
    return fiveHeight * index + fifteenHeight / 2.0;
  }

  DateTime _getTimeFromPosition(double position) {
    final index = (position - fifteenHeight / 2.0) / fullHeight;
    if (index <= 0.0) return DateTime(1, 1, 1, 0, 0);
    final minutes = index * 24 * 60;
    final t = DateTime(1, 1, 1, minutes ~/ 60, (minutes % 60 / 5).round() * 5);
    if (t.isAfter(DateTime(1, 1, 1, 23, 45))) return DateTime(1, 1, 1, 23, 45);
    return t;
  }
}

class HomeController extends GetxController {
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
    // if (draggedSlot.hashCode != slot.hashCode) return;
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
