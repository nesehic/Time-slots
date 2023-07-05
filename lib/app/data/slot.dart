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
  final int day;
  String get text => '$start - $end';

  Slot(double position, {this.day = 0}) {
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
    if (t.isAfter(DateTime(1, 1, 1, 23, 0))) return DateTime(1, 1, 1, 23, 0);
    return t;
  }
}
