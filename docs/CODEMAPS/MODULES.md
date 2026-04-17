<!-- Generated: 2026-04-17 | Files scanned: 55 | Token estimate: ~700 -->
# Modules Codemap

**Last Updated:** 2026-04-17

## Module Overview

Maxtivity consists of 5 feature modules following MVC pattern. Auth (Login/SignUp) is present but the main UX is the Pomodoro timer (Home) and its session history.

---

## 1. Splash Module

**Path:** `lib/modules/splash/`

```
splash/
├── controller/splash_controller.dart
└── view/splash_screen.dart
```

- Checks auth state on `onInit()`
- Navigates to `HomeView` or `LoginView`

---

## 2. Login Module

**Path:** `lib/modules/login/`

```
login/
├── controller/login_controller.dart
├── model/login_model.dart
├── repository/login_repository.dart
├── view/login_view.dart
└── widgets/password_visibility.dart
```

- Email + password form
- `PasswordVisibility` widget toggles obscure text
- On success → navigate to HomeView

---

## 3. SignUp Module

**Path:** `lib/modules/sign_up/`

```
sign_up/
├── controller/signup_controller.dart
├── signup_repository/signup_repository.dart
└── view/signup_view.dart
```

- Registration form with validation
- On success → navigate to LoginView or HomeView

---

## 4. Home Module (Main Feature)

**Path:** `lib/modules/home/`

```
home/
├── controller/home_controller.dart
├── repository/home_repository.dart
└── view/home_view.dart
```

### HomeController
```dart
class HomeController extends GetxController {
  late Timer timer;
  double progressValue = 1;
  int secondsPassed = 0;
  int selectedTimeIndex = 1;  // default → 10 min
  bool isPaused = true;
  DateTime? startTime;
  DateTime? endTime;

  final List<Map<String, dynamic>> timeOptions = [
    {'label': '5 min', 'value': 5},
    {'label': '10 min', 'value': 10},
    {'label': '15 min', 'value': 15},
    {'label': '25 min', 'value': 25},
    {'label': '30 min', 'value': 30},
    {'label': '45 min', 'value': 45},
    {'label': '60 min', 'value': 60},
  ];
  int get timeInterval => timeOptions[selectedTimeIndex]['value'];

  void startTimer();           // starts 1-second periodic timer
  void pauseTimer({bool pause = false}); // pause=false → cancel, pause=true → resume
  void resetTimer();           // cancels timer, resets state
  void setTimeInterval(int index);  // changes duration, resets timer
  String getMinutes();         // returns "MM:SS" display string
  void saveTime();             // saves HistoryModel to objectBox.historyBox
}
```

### HomeRepository
```dart
class HomeRepository {
  // Optional backend save (HTTP) — local save happens directly in controller
  Future<String> saveTime(DateTime startTime, DateTime endTime);
}
```

### HomeView
```
HomeView
├── SidebarButton (top-left → opens CustomDrawer)
├── DropdownButton<int> (time selector: 5/10/15/25/30/45/60 min)
├── CircularProgressIndicator + "MM:SS" text (center)
└── Buttons (bottom):
    ├── isPaused=true  → PrimaryButton("Start")
    └── isPaused=false → Row [
            PrimaryButton("Pause"/"Resume"),
            PrimaryButton("Reset")
        ]
```

### Timer Logic
```
progressValue = (timeInterval*60 - secondsPassed) / (timeInterval*60)

On complete (secondsPassed == timeInterval*60):
  → saveTime() stores HistoryModel to ObjectBox
  → resetTimer()
```

---

## 5. History Module

**Path:** `lib/modules/history/`

```
history/
├── controller/history_controller.dart
├── model/history_model.dart
├── repository/history_repository.dart
└── view/history_view.dart
```

### HistoryController
```dart
class HistoryController extends GetxController {
  RxBool isLoading = false.obs;
  List<HistoryModel> historyList = [];

  void getHistory();  // loads objectBox.historyBox.getAll(), sorted newest-first
}
```
Note: reads directly from `objectBox` global, no repository dependency.

### HistoryView
```
HistoryView
├── SidebarButton (top-left → opens CustomDrawer)
└── ListView of session cards showing:
    ├── Start Time (formatted via extension)
    └── End Time (formatted via extension)
    (empty state: "No History Found")
```

---

## Navigation (CustomDrawer)

**File:** `lib/utils/ui/drawer/custom_drawer.dart`

Active drawer items:
- **Home** → `Get.off(() => HomeView())`
- **History** → `Get.off(() => HistoryView())`

Logout item exists but is **commented out**.

---

## Module Dependency Graph

```
SplashPage
  ↓ onInit checks auth
  ├── LoginView ──→ HomeView
  └── HomeView (primary)
       ↓ CustomDrawer
       └── HistoryView
```

---

## Inter-Module Communication

| From | To | Method |
|------|----|----|
| SplashController | HomeView / LoginView | Get.offAllNamed() |
| LoginController | HomeView | Get.offAllNamed('/home') |
| HomeView | HistoryView | CustomDrawer Get.off() |
| HomeController | objectBox.historyBox | Direct ObjectBox write |
| HistoryController | objectBox.historyBox | Direct ObjectBox read |

---

See also:
- [APP_ARCHITECTURE.md](APP_ARCHITECTURE.md) for MVC pattern details
- [DATA_LAYER.md](DATA_LAYER.md) for model definitions
- [UTILS_SERVICES.md](UTILS_SERVICES.md) for API and storage
