import 'package:get/get.dart';
import 'package:intl/intl.dart';

final formatHHmm = DateFormat('HH:mm');

const fifteenHeight = 40.0;
const fiveHeight = fifteenHeight / 3.0;
const fourtyFiveHeight = fifteenHeight * 3.0;

class Slot {
  double position;
  String start;
  String end;
  String get text => '$start - $end';
  Slot(this.position, this.start, this.end);
}

class HomeController extends GetxController {
  final firstPositionY = 0.0;
  double dragOffset = 0.0;

  final slots = <Slot>[].obs;

  List<DateTime> getTimesFromMiddle(DateTime time) {
    final start = time.add(const Duration(days: 1, minutes: -20));
    final end = start.add(const Duration(minutes: 45));

    if (start.day == 1) {
      return [formatHHmm.parse('00:00'), formatHHmm.parse('00:45')];
    }
    if (end.hour == 23 && end.minute > 25 ||
        end.hour == 0 && end.minute == 10) {
      return [formatHHmm.parse('23:00'), formatHHmm.parse('23:45')];
    }
    return [start, end];
  }

  double getPositionFromTime(DateTime start) {
    final minutes = start.hour * 60 + start.minute;
    final index = minutes / 5;
    return fiveHeight * index + fifteenHeight / 2.0;
  }

  void dragSlot(Slot slot) {
    final isUp = dragOffset < fiveHeight;
    if (slot.start == '00:00' && isUp || slot.end == '23:45' && !isUp) return;
    final doubleSlot = doubleSlotIndex(slot);
    if (doubleSlot == 0 && isUp || doubleSlot == 1 && !isUp) return;

    final offset = [slot.start, slot.end].map((e) => formatHHmm
        .format(formatHHmm.parse(e).add(Duration(minutes: isUp ? -5 : 5))));
    final movedSlot = Slot(
      slot.position + (isUp ? -fiveHeight : fiveHeight),
      offset.first,
      offset.last,
    );

    if (chainLength(movedSlot, slots.toList()..remove(slot)) >= 3) return;

    slot.position = movedSlot.position;
    slot.start = movedSlot.start;
    slot.end = movedSlot.end;
    slots.refresh();
  }

  int chainLength(Slot slot, List<Slot> slots) {
    slots.remove(slot);
    for (final other in slots) {
      if (slot.start == other.end || slot.end == other.start) {
        return chainLength(other, slots) + 1;
      }
    }
    return 1;
  }

  int doubleSlotIndex(Slot slot) {
    for (final other in slots) {
      if (slot.start == other.end) return 0;
      if (slot.end == other.start) return 1;
    }
    return -1;
  }

  bool hasCollision(Slot slot) {
    for (final other in slots) {
      if ((slot.position - other.position).abs() < fourtyFiveHeight) {
        return true;
      }
    }
    if (chainLength(slot, slots.toList()) >= 3) return true;
    return false;
  }
}
