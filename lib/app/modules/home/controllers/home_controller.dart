import 'package:get/get.dart';
import 'package:intl/intl.dart';

final formatHHmm = DateFormat('HH:mm');

class HomeController extends GetxController {
  final fifteenHeight = 60.0; // Must be divisible by 3 and 2
  late final fiveHeight = fifteenHeight / 3.0;
  late final fourtyFiveHeight = fifteenHeight * 3.0;

  final firstPositionY = 0.0;
  final position = 0.0.obs;
  String text = '00:00 - 00:45';

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
}
