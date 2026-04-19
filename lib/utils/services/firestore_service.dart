import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService _instance = FirestoreService._();
  factory FirestoreService() => _instance;

  final _db = FirebaseFirestore.instance;

  Future<void> syncSession(HistoryModel session, String uid) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .doc(session.id.toString())
          .set({
        'startTime': Timestamp.fromDate(session.startTime),
        'endTime': Timestamp.fromDate(session.endTime),
        'durationMinutes': session.durationMinutes,
        'completed': session.completed,
      });
    } catch (e) {
      debugPrint('FirestoreService: sync failed — $e');
    }
  }
}
