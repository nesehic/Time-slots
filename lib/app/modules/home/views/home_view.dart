import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timetable/app/modules/daily/views/daily_table.dart';
import 'package:timetable/app/modules/weekly/views/weekly_table.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.isWeekly.toggle(),
        child: const Icon(Icons.swap_horiz),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isWeekly.value) {
            return WeeklyTable(controller.weeklyController);
          }
          return DailyTable(controller.dailyController);
        }),
      ),
    );
  }
}
