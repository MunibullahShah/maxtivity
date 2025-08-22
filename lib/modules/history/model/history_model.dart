import 'package:objectbox/objectbox.dart';

@Entity()
class HistoryModel {
  @Id()
  int id = 0;

  DateTime startTime;
  DateTime endTime;
  int durationMinutes;
  bool completed;

  HistoryModel({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.completed,
  });
}
