import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _soundAsset = 'sounds/alarm.mp3';
const _channelId = 'maxtivity_alarm';
const _channelName = 'Pomodoro Alarm';
const _notificationId = 1001;

class AlarmService {
  AlarmService._();
  static final AlarmService _instance = AlarmService._();
  factory AlarmService() => _instance;

  final _notifications = FlutterLocalNotificationsPlugin();
  final _player = AudioPlayer();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );

    await _requestPermissions();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> playAlarm() async {
    await _playSound();
    await _showNotification();
  }

  Future<void> _playSound() async {
    try {
      await _player.play(AssetSource(_soundAsset));
    } catch (e) {
      debugPrint('AlarmService: could not play sound — $e');
      debugPrint('Place an alarm.mp3 file in assets/sounds/');
    }
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _notifications.show(
      _notificationId,
      'Pomodoro Complete!',
      'Great work — your session is done.',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  Future<void> stopAlarm() async {
    await _player.stop();
    await _notifications.cancel(_notificationId);
  }
}
