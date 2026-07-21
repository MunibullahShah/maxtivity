import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';
import 'package:maxtivity/main.dart';
import 'package:maxtivity/utils/services/alarm_service.dart';
import 'package:maxtivity/utils/services/firebase_auth_service.dart';
import 'package:maxtivity/utils/services/firestore_service.dart';
import 'package:maxtivity/utils/services/local_storage_service.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

const _lockKey = 'is_locked';
const _selectedIndexKey = 'selected_time_index';
const _customSecondsKey = 'custom_duration_seconds';

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
    {'label': 'Custom...', 'value': -1},
  ];
  int selectedTimeIndex = 1;
  int? customDurationSeconds;

  int get totalSeconds {
    if (selectedTimeIndex == timeOptions.length - 1) {
      return customDurationSeconds ?? (25 * 60);
    }
    return timeOptions[selectedTimeIndex]['value'] * 60;
  }

  /// Whole minutes of the currently configured custom duration, or `null`
  /// when no custom duration has been set. Used to label the dropdown option.
  int? get customMinutes =>
      customDurationSeconds == null ? null : customDurationSeconds! ~/ 60;

  bool isPaused = true;
  bool isLocked = false;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void onInit() {
    super.onInit();
    _loadPersistedState();
  }

  /// Restores the lock state and the last-selected session duration so the
  /// user's preferences survive an app restart.
  Future<void> _loadPersistedState() async {
    final storage = LocalStorageService();
    isLocked = (await storage.readBool(_lockKey)) ?? false;

    final savedCustom = await storage.readInt(_customSecondsKey);
    if (savedCustom != null) {
      customDurationSeconds = savedCustom;
    }

    final savedIndex = await storage.readInt(_selectedIndexKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < timeOptions.length) {
      selectedTimeIndex = savedIndex;
    }

    progressValue = 1;
    update();
  }

  void startTimer() {
    isPaused = false;
    startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      progressValue = (totalSeconds - secondsPassed) / totalSeconds;
      update();
      secondsPassed++;
      if (secondsPassed == totalSeconds) {
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
    int remaining = totalSeconds - secondsPassed;
    int min = remaining ~/ 60;
    int sec = remaining % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  void resetTimer() {
    if (timer.isActive) {
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
      LocalStorageService().writeInt(_selectedIndexKey, index);
      if (index != timeOptions.length - 1) {
        resetTimer();
      }
      update();
    }
  }

  void setCustomTime(int minutes, int seconds) {
    customDurationSeconds = minutes * 60 + seconds;
    LocalStorageService().writeInt(_customSecondsKey, customDurationSeconds!);
    resetTimer();
  }

  void toggleLock() {
    isLocked = !isLocked;
    LocalStorageService().writeBool(_lockKey, value: isLocked);
    update();
  }

  void saveTime() {
    try {
      endTime = DateTime.now();
      if (startTime != null && endTime != null) {
        final session = HistoryModel(
          startTime: startTime!,
          endTime: endTime!,
          durationMinutes: totalSeconds ~/ 60,
          completed: secondsPassed >= totalSeconds,
        );

        objectBox.historyBox.put(session);
        AlarmService().playAlarm();
        final auth = FirebaseAuthService.to;
        if (auth.isLoggedIn) {
          FirestoreService().syncSession(session, auth.uid!);
        }
        getSuccessSnackbar(
          title: "Success",
          message: "Session saved successfully",
        );
      }
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }
}
