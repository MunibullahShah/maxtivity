<!-- Generated: 2026-04-17 | Files scanned: 55 | Token estimate: ~600 -->
# Data Layer Codemap

**Last Updated:** 2026-04-17

## Overview

The data layer defines ObjectBox entities and models used for local persistence. Auth-related data is handled by the backend and stored in `SharedPreferences` (token). Session history is stored exclusively in ObjectBox.

---

## Data Models

### 1. UserModel

**File:** `lib/utils/models/user_model.dart`
**Storage:** ObjectBox (`userBox`)

```dart
@Entity()
class UserModel {
  @Id(assignable: true)
  int? id;

  String? name;
  String? email;
  String? password;

  UserModel({this.id, this.name, this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### 2. HistoryModel (Session History)

**File:** `lib/modules/history/model/history_model.dart`
**Storage:** ObjectBox (`historyBox`)

```dart
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
```

### 3. LoginModel

**File:** `lib/modules/login/model/login_model.dart`
**Storage:** In-memory (transient)

Used for API response parsing and passing auth credentials. Specific fields depend on backend contract.

---

## ObjectBox Setup

**File:** `lib/utils/services/object_box.dart`

```dart
class ObjectBox {
  late final Store store;
  late final Box<UserModel> userBox;
  late final Box<HistoryModel> historyBox;

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }

  UserModel getUser(int id);
  int putUser(UserModel user);
  void removeUser();       // removes by global `user` variable
  void removeAllUsers();
}
```

Global singleton accessed as `objectBox` (declared in `main.dart`):
- `objectBox.historyBox.getAll()` — fetch all sessions
- `objectBox.historyBox.put(session)` — save a session

---

## Data Persistence Patterns

### Save a session (in HomeController)
```dart
final session = HistoryModel(
  startTime: startTime!,
  endTime: endTime!,
  durationMinutes: timeInterval,
  completed: secondsPassed >= (timeInterval * 60),
);
objectBox.historyBox.put(session);
```

### Read all sessions (in HistoryController)
```dart
historyList = objectBox.historyBox.getAll();
historyList.sort((a, b) => b.startTime.compareTo(a.startTime));
```

---

## Data Type Mapping

| Dart Type | ObjectBox Type | Notes |
|-----------|----------------|-------|
| `int` | `long` | ObjectBox IDs |
| `String` | `string` | |
| `DateTime` | `date` | Stored as ms since epoch |
| `bool` | `bool` | |

---

See also:
- [UTILS_SERVICES.md](UTILS_SERVICES.md) for storage services
- [MODULES.md](MODULES.md) for model usage in controllers
