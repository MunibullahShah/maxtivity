import 'dart:async';

import 'package:get/get.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';
import 'package:maxtivity/main.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class HomeController extends GetxController {
  late Timer timer;
  double progressValue = 1;
  int secondsPassed = 0;
  final List<Map<String, dynamic>> timeOptions = [
    {'label': '5 min', 'value': 5},
    {'label': '10 min', 'value': 10},
    {'label': '15 min', 'value': 15},
    {'label': '25 min', 'value': 25},
    {'label': '30 min', 'value': 30},
    {'label': '45 min', 'value': 45},
    {'label': '60 min', 'value': 60},
  ];
  int selectedTimeIndex = 1; // Default to 25 minutes
  int get timeInterval => timeOptions[selectedTimeIndex]['value'];
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
    return "${min}:${sec.toString().padLeft(2, '0')}";
  }

  void resetTimer() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    isPaused = true;
    secondsPassed = 0;
    progressValue = 1;
    update();
  }

  void setTimeInterval(int index) {
    if (index >= 0 && index < timeOptions.length) {
      selectedTimeIndex = index;
      resetTimer();
    }
  }

  void saveTime() {
    try {
      endTime = DateTime.now();
      if (startTime != null && endTime != null) {
        final session = HistoryModel(
          startTime: startTime!,
          endTime: endTime!,
          durationMinutes: timeInterval,
          completed: secondsPassed >= (timeInterval * 60),
        );

        objectBox.historyBox.put(session);
        getSuccessSnackbar(
          title: "Success",
          message: "Session saved successfully",
        );
      }
    } catch (e) {
      print('Error saving session: $e');
    }
  }
}
