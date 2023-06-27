import 'package:get/get.dart';
import 'package:intl/intl.dart';

final formatHHmm = DateFormat('HH:mm');

const fifteenHeight = 60.0;
const fiveHeight = fifteenHeight / 3.0;
const fourtyFiveHeight = fifteenHeight * 3.0;

class Slot {
  final position = (-fourtyFiveHeight).obs;
  String text = '00:00 - 00:45';
}

class HomeController extends GetxController {
  final firstPositionY = 0.0;
  double dragOffset = 0.0;

  final slot = Slot();

  List<DateTime> getTimesFromMiddle(DateTime time) {
    final start = time.add(const Duration(days: 1, minutes: -20));
    final end = start.add(const Duration(minutes: 45));

    // Edge cases
    if (start.day == 1) {
      return [formatHHmm.parse('00:00'), formatHHmm.parse('00:45')];
    }
    if (end.hour == 23 && end.minute > 25) {
      return [formatHHmm.parse('23:00'), formatHHmm.parse('23:45')];
    }

    return [start, end];
  }

  double getPositionFromTime(DateTime start) {
    final minutes = start.hour * 60 + start.minute;
    final index = minutes / 5;
    return fiveHeight * index + fifteenHeight / 2.0;
  }

  void addPosition(Slot slot) {
    final isUp = dragOffset < fiveHeight;
    final edgeCases = ['00:00', '23:45'];
    final times = slot.text.split(' - ');
    if (edgeCases[0] == times[0] && isUp || edgeCases[1] == times[1] && !isUp) {
      return;
    }
    slot.position.value += isUp ? -fiveHeight : fiveHeight;
    slot.text = slot.text
        .split(' - ')
        .map((e) => formatHHmm
            .format(formatHHmm.parse(e).add(Duration(minutes: isUp ? -5 : 5))))
        .join(' - ');
  }
}
