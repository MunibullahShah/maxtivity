# App Architecture Codemap

**Last Updated:** 2026-04-17
**Entry Points:** `lib/main.dart`

## Architecture Overview

Maxtivity uses a **GetX-based MVC architecture** with a **Repository pattern** for data access. The app follows clean separation between UI (View), business logic (Controller), and data access (Repository).

---

## Application Initialization

### main.dart
```dart
late ObjectBox objectBox;  // Global ObjectBox instance

Future<void> main() async {
  // 1. Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize ObjectBox (local database)
  objectBox = await ObjectBox.create();
  
  // 3. Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // 4. Run app
  runApp(const MyApp());
}
```

### MyApp Widget
```
MyApp (StatelessWidget)
  └─ Sizer (responsive sizing wrapper)
      └─ GetMaterialApp (navigation & state management)
          ├─ Theme: AppTheme().appLightTheme
          ├─ debugShowCheckedModeBanner: false
          └─ Routes:
              ├─ '/': SplashPage()
              └─ '/home': HomeView()
```

---

## Navigation Architecture

### Route Management
- **Framework:** GetX routing system
- **Named Routes:** Defined in `main.dart`
- **Default Route:** '/' (SplashPage)
- **Home Route:** '/home' (HomeView)

### Route Definitions
```dart
routes: {
  '/': (context) => SplashPage(),
  homeRoute: (context) => HomeView(),
}
```

### Navigation Methods
```dart
// Push replacement (full navigation flow)
Get.offAllNamed('/home');

// Push new route
Get.toNamed('/login');

// Go back
Get.back();

// Snackbar notifications
ShowSnackBar.show(message: 'Success');
```

---

## Dependency Injection & GetX Setup

### Controller Registration Pattern

**View Registration:**
```dart
final HomeController homeController = Get.put(HomeController(), permanent: true);
```

**Usage in Widgets:**
```dart
GetBuilder<HomeController>(
  assignId: true,
  builder: (logic) {
    return Scaffold(body: ...);
  },
);
```

### GetxController Lifecycle
```
onInit()        // Initialize
onReady()       // Controller ready
onClose()       // Cleanup
```

---

## Configuration Layer

### Theme Configuration (app_theme.dart)
```
AppTheme
├─ appLightTheme: ThemeData
│  ├─ primaryColor
│  ├─ scaffoldBackgroundColor
│  ├─ textTheme
│  ├─ appBarTheme
│  └─ buttonTheme
├─ appDarkTheme: ThemeData
└─ colorScheme
```

### App Colors (app_colors.dart)
- Primary, secondary, accent colors
- Text colors (dark, light, grey)
- Status colors (success, error, warning)
- Background colors

### Text Styles (app_text_styles.dart)
- Heading styles (h1, h2, h3, h4, h5, h6)
- Body styles (body1, body2)
- Caption and label styles

### Constants (app_constants.dart)
- API base URLs
- Timeout values
- Error messages
- Default values

---

## Data Flow Architecture

### Typical Module Data Flow

```
View (Widget)
  ↓ (user interaction)
Controller (GetxController)
  ↓ (calls repository method)
Repository (Repository class)
  ├─ API Call (backend_calls.dart)
  └─ LocalStorage (ObjectBox, SharedPreferences)
      ↓ (returns data)
Model (Dart classes)
  ↓ (controller processes)
View (UI updates via GetBuilder)
```

### API Response Handling

```dart
// general_api_state.dart
enum ApiState { INITIAL, LOADING, LOADED, ERROR }

class ApiResponse<T> {
  final ApiState apiState;
  final T? data;
  final String? message;
  final int? statusCode;
}
```

---

## Module Architecture Pattern (MVC)

Each feature module follows this structure:

```
modules/[feature]/
├── controller/
│   └── [feature]_controller.dart    # State & business logic
├── repository/
│   └── [feature]_repository.dart    # Data access
├── model/
│   └── [feature]_model.dart         # Data classes
├── view/
│   ├── [feature]_view.dart          # Main screen
│   └── widgets/                     # Local widgets
└── widgets/                         # Shared widgets (optional)
```

### Example: Home Module

```
modules/home/
├── controller/
│   └── home_controller.dart
│       ├─ Timer management
│       ├─ State variables
│       └─ Business logic
├── repository/
│   └── home_repository.dart
│       ├─ Save history
│       ├─ Fetch history
│       └─ API calls
├── view/
│   └── home_view.dart
│       ├─ Timer display
│       ├─ Control buttons
│       ├─ Drawer navigation
│       └─ Status display
└── [no model needed - uses shared History model]
```

---

## Global Services

### ObjectBox Service (Singleton)
```dart
late ObjectBox objectBox;  // Global instance

class ObjectBox {
  late final Store store;
  
  static Future<ObjectBox> create() async {
    // Initialize ObjectBox store
    // Setup entity managers
  }
}

// Access globally: objectBox.historyBox.getAll();
```

### Responsive Sizing (Sizer)
```dart
// Wraps entire app for responsive scaling
Sizer(
  builder: (context, orientation, deviceType) {
    return GetMaterialApp(...);
  },
);

// Usage in widgets:
Container(width: 80.w)  // 80% of screen width
Container(height: 15.h) // 15% of screen height
Container(fontSize: 12.sp) // Responsive font size
```

---

## Architecture Benefits

| Pattern | Benefit |
|---------|---------|
| **MVC with Repository** | Clear separation of concerns |
| **GetX** | Easy state management, lightweight |
| **ObjectBox** | Fast local storage, type-safe queries |
| **Dependency Injection** | Testable, loosely coupled components |
| **Responsive Sizing** | Works across devices |
| **Named Routes** | Type-safe navigation |

---

## Key Files Reference

| File | Purpose | Size |
|------|---------|------|
| main.dart | App entry, initialization | ~45 lines |
| app_theme.dart | Theme configuration | ~150 lines |
| app_colors.dart | Color palette | ~50 lines |
| app_constants.dart | Constants | ~30 lines |
| endpoints.dart | API endpoints | ~20 lines |

---

## Initialization Sequence

```
1. main() called
2. WidgetsFlutterBinding.ensureInitialized()
3. ObjectBox.create() - async
4. SystemChrome.setPreferredOrientations()
5. runApp(MyApp())
6. SplashPage() shown first
7. Splash controller initializes (SplashController)
8. Navigation to Home or Login based on auth state
```

---

See also: [MODULES.md](MODULES.md) for detailed module documentation
