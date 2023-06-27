import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final format = DateFormat('hh:mm');

class HomeController extends GetxController {
  final position = Offset.zero.obs;
  final scroll = ScrollController();

  // Format from - to
  String selectedTime = "";
}
