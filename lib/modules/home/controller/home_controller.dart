import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maxtivity/modules/home/repository/home_repository.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class HomeController extends GetxController {
  late Timer timer;
  double progressValue = 1;
  int secondsPassed = 0;
  int timeInterval = 25;
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
      progressValue =
          ((timeInterval * 60) - secondsPassed) / (timeInterval * 60);
      update();
      secondsPassed++;
      if (secondsPassed == (timeInterval * 60)) {
        saveTime();
        resetTimer();
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
    int minutes = (timeInterval * 60) - secondsPassed;
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
    try {
      endTime = DateTime.now();
      String response = await HomeRepository().saveTime(startTime!, endTime!);
      if (response == "200") {
        getSuccessSnackbar(
            title: "Success", message: "Time Saved Successfully");
      }
    } catch (e) {}
  }
}
