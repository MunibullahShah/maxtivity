import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maxtivity/main.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';

/// Focus time recorded on a single calendar day. Used to drive the
/// last-7-days mini bar chart on the statistics screen.
class DailyFocus {
  final DateTime day;
  final int minutes;

  const DailyFocus({required this.day, required this.minutes});
}

/// Derives focus statistics and streaks from the sessions already stored in
/// ObjectBox. Purely a read/aggregate layer — it never mutates stored data.
class StatsController extends GetxController {
  int totalSessions = 0;
  int completedSessions = 0;
  int totalFocusMinutes = 0;
  int todayMinutes = 0;
  int weekMinutes = 0;
  int currentStreak = 0;
  int longestStreak = 0;

  /// Completion rate in the range 0.0 – 1.0.
  double completionRate = 0;

  /// Minutes focused for each of the last 7 days (oldest first).
  List<DailyFocus> last7Days = [];

  @override
  void onInit() {
    super.onInit();
    computeStats();
  }

  void computeStats() {
    try {
      final sessions = objectBox.historyBox.getAll();

      totalSessions = sessions.length;
      completedSessions = sessions.where((s) => s.completed).length;
      totalFocusMinutes =
          sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
      completionRate =
          totalSessions == 0 ? 0 : completedSessions / totalSessions;

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      // weekday: Mon = 1 ... Sun = 7
      final startOfWeek =
          startOfToday.subtract(Duration(days: now.weekday - 1));

      todayMinutes = sessions
          .where((s) => !s.startTime.isBefore(startOfToday))
          .fold<int>(0, (sum, s) => sum + s.durationMinutes);
      weekMinutes = sessions
          .where((s) => !s.startTime.isBefore(startOfWeek))
          .fold<int>(0, (sum, s) => sum + s.durationMinutes);

      last7Days = List.generate(7, (i) {
        final day = startOfToday.subtract(Duration(days: 6 - i));
        final nextDay = day.add(const Duration(days: 1));
        final minutes = sessions
            .where((s) =>
                !s.startTime.isBefore(day) && s.startTime.isBefore(nextDay))
            .fold<int>(0, (sum, s) => sum + s.durationMinutes);
        return DailyFocus(day: day, minutes: minutes);
      });

      _computeStreaks(sessions);
      update();
    } catch (e) {
      debugPrint('Error computing stats: $e');
    }
  }

  void _computeStreaks(List<HistoryModel> sessions) {
    // Distinct calendar days that contain at least one completed session.
    final dates = sessions
        .where((s) => s.completed)
        .map((s) =>
            DateTime(s.startTime.year, s.startTime.month, s.startTime.day))
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty) {
      currentStreak = 0;
      longestStreak = 0;
      return;
    }

    // Longest run of consecutive days anywhere in the history.
    int longest = 1;
    int running = 1;
    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        running++;
      } else if (diff > 1) {
        running = 1;
      }
      if (running > longest) longest = running;
    }
    longestStreak = longest;

    // Current streak counts back from today (a streak that ended yesterday is
    // still "current" until the day is over).
    final dateSet = dates.toSet();
    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month, now.day);
    if (!dateSet.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    int streak = 0;
    while (dateSet.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    currentStreak = streak;
  }
}
