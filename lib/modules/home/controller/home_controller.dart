import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late Timer timer;
  double progressValue = 1;
  int secondsPassed = 0;
  bool isPaused = true;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void onInit() {
    super.onInit();
  }

  void startTimer() {
    isPaused = false;
    startTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      progressValue = ((25 * 60) - secondsPassed) / (25 * 60);
      update();
      secondsPassed++;
      if (secondsPassed == (25 * 60)) {
        saveTime();
        pauseTimer();
      }
    });
  }

  void pauseTimer({bool pause = false}) {
    if (pause) {
      startTimer();
    } else {
      timer.cancel();
    }
    update();
  }

  String getMinutes() {
    int minutes = (1 * 60) - secondsPassed;
    int min = minutes ~/ 60;
    int sec = minutes % 60;
    return "${min}:${sec}";
  }

  void resetTimer() {
    timer.cancel();
    isPaused = true;
    secondsPassed = 0;
    progressValue = 1;
    update();
  }

  void saveTime() async {
    endTime = DateTime.now();
    var data = HomeRepository().saveTime(startTime!, endTime!);
  }
}
