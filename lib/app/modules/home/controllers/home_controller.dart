import 'package:get/get.dart';
import 'package:timetable/app/modules/daily/controllers/daily_controller.dart';
import 'package:timetable/app/modules/weekly/controllers/weekly_controller.dart';

class HomeController extends GetxController {
  final dailyController = DailyController();
  final weeklyController = WeeklyController();
  final isWeekly = false.obs;
}
