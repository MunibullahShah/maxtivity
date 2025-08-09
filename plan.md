# Pomodoro App – Development Plan

## 1. Goals & Scope

Build a productive Pomodoro-style timer inside the existing **maxtivity** Flutter codebase.  
Key required features:

1. Riverpod-based state management (already in pubspec, extend usage).
2. Firebase backend for auth & cloud sync of sessions.
3. Local + push notifications when cycles finish.
4. Screen‐lock / keep-awake behaviour to minimise distractions.
5. Ability to extend an active timer (customisable extra minutes).

---

## 2. Key Packages

| Purpose             | Package                                       | Notes                                                                    |
| ------------------- | --------------------------------------------- | ------------------------------------------------------------------------ |
| State-mgmt          | `flutter_riverpod`                            | Already present; create **PomodoroTimerProvider** & **SettingsProvider** |
| Local notifications | `flutter_local_notifications`                 | Schedule finish alerts & reminders even in background                    |
| Background work     | `workmanager` or `android_alarm_manager_plus` | Ensure timer continues when app is killed (Android)                      |
| Keep screen awake   | `wakelock_plus`                               | Prevent auto-lock while the focus screen is open                         |
| Firebase core       | `firebase_core`                               | Already added                                                            |
| Cloud storage       | `cloud_firestore`                             | Persist session history & user prefs                                     |
| Push notifications  | `firebase_messaging`                          | Optional – cross-device reminders                                        |

Add these to `pubspec.yaml` under dependencies.

---

## 3. Architecture Overview

```
lib/
  ├─ features/
  │    ├─ pomodoro/
  │    │    ├─ data/
  │    │    │     ├─ models/
  │    │    │     └─ repositories/
  │    │    ├─ logic/
  │    │    │     └─ providers/  (Riverpod)
  │    │    └─ ui/
  │    │          ├─ pages/
  │    │          └─ widgets/
  │    └─ settings/
  └─ services/ (notifications, screen_lock, firebase etc.)
```

Keep existing `modules/` for legacy views; new code lives in `features/`.

---

## 4. Data Model

```dart
@freezed
class PomodoroSession with _$PomodoroSession {
  const factory PomodoroSession({
    required String id,
    required DateTime startTime,
    required int targetMinutes,
    required int elapsedSeconds,
    required bool isBreak,
  }) = _PomodoroSession;
}
```

Store in Firestore under `/users/{uid}/sessions`.

---

## 5. Timer Mechanics

• Use `Timer.periodic` inside a `StateNotifier` (Riverpod).  
• Persist current session to local storage (SharedPreferences/ObjectBox) so it can resume after app restart.  
• When starting/pausing/extending, emit states: _running_, _paused_, _completed_.

### Extend Time

Provide a “+1 / +5 min” action; update `targetMinutes` and reschedule notifications.

---

## 6. Notifications

1. **Immediate** – show real-time countdown UI.
2. **Local** – schedule a notification at expected finish time via `flutter_local_notifications`.
3. **Push** (optional) – send FCM message if user closes app completely.

Edge-cases: when time is extended or timer is cancelled, update/cancel scheduled notifications accordingly.

---

## 7. Screen Lock / Keep Awake

• Use `wakelock_plus.enable()` when timer screen is visible to keep the display on.  
• Optionally use `ScreenCaptureEvent` APIs to lock screen orientation & hide system UI for focus mode.

---

## 8. Firebase Integration

1. **Auth** – Email/Google sign-in so sessions sync per user.
2. **Firestore** – Save each completed session & settings (pomodoro length, break length).
3. **Cloud Functions** (future) – Aggregate stats for weekly reports.

---

## 9. Navigation

Keep `auto_route` setup. Add routes:

```dart
AutoRoute(page: TimerPage, initial: true),
AutoRoute(page: HistoryPage),
AutoRoute(page: SettingsPage),
```

---

## 10. Milestones & Tasks

1. **Project Setup**  
   • Add required packages & run `flutter pub get`.  
   • Configure iOS/Android permissions for notifications.
2. **Domain Layer**  
   • Create `PomodoroSession` model.  
   • Implement `PomodoroRepository` (local + cloud sync).
3. **State Management**  
   • Build `PomodoroTimerNotifier` (`StateNotifier<PomodoroState>`).  
   • Provide `SettingsNotifier`.
4. **UI / Timer Screen**  
   • Circular progress + controls (Start/Pause/Stop/Extend).  
   • Keep-awake integration.
5. **Notifications**  
   • Initialize plugin, schedule/cancel on state changes.  
   • Handle background callback.
6. **History & Stats** screen  
   • List stored sessions, filter by date, show totals.
7. **Settings** screen  
   • Work / break length, theme toggle, notification sounds.
8. **Polish & QA**  
   • Dark-mode support, accessibility, testing.
9. **Release**  
   • Update store listings, icons, CI/CD workflows.

---

## 11. Next Steps (Week 1)

- [ ] Add packages & platform configs.
- [ ] Scaffold directory structure.
- [ ] Implement `PomodoroSession` model and Firestore collection helper.
- [ ] Draft `PomodoroTimerNotifier` with start/stop logic.
- [ ] Create minimal `TimerPage` that displays countdown.

> _Update this plan as tasks complete or requirements evolve._
