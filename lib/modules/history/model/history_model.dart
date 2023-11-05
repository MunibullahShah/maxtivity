class HistoryModel {
  DateTime? startTime;
  DateTime? endTime;

  HistoryModel({
    this.startTime,
    this.endTime,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    startTime =
        json['startTime'] != null ? DateTime.parse(json['startTime']) : null;
    endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endTime'] = startTime?.toIso8601String();
    data['endTime'] = endTime?.toIso8601String();
    return data;
  }
}
