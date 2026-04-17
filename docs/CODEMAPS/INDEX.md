# Maxtivity Codemaps Index

**Last Updated:** 2026-04-17 (rev 2)

## Project Overview

**Maxtivity** is a Flutter Pomodoro timer application that helps users manage their time and track productivity sessions.

### Technology Stack
- **Framework:** Flutter 3.1.4+
- **State Management:** GetX (get: ^4.6.6)
- **Local Storage:** ObjectBox 2.3.1
- **Networking:** HTTP 1.1.0
- **Architecture:** MVC with Repository pattern

### Key Dependencies
- `google_fonts: ^6.1.0` - Custom fonts
- `intl: ^0.18.1` - Date/time localization
- `image_picker: ^1.0.4` - Image selection
- `shared_preferences: ^2.0.15` - Key-value storage
- `lottie: ^2.7.0` - Loading animations
- `shimmer: ^3.0.0` - Shimmer loading effects
- `sizer: ^2.0.15` - Responsive sizing

---

## Codemap Files

| Document | Purpose | Key Topics |
|----------|---------|-----------|
| [APP_ARCHITECTURE.md](APP_ARCHITECTURE.md) | App structure, navigation, initialization | Entry points, routing, lifecycle, initialization flow |
| [MODULES.md](MODULES.md) | Feature modules and flows | Splash, Login, SignUp, Home, History |
| [UTILS_SERVICES.md](UTILS_SERVICES.md) | Shared utilities, services, networking | API layer, local storage, helpers, services |
| [UI_COMPONENTS.md](UI_COMPONENTS.md) | Reusable UI components and widgets | Buttons, textfields, dialogs, dropdowns, custom widgets |
| [DATA_LAYER.md](DATA_LAYER.md) | Data models and persistence | User model, history model, ObjectBox setup |

---

## Architecture Diagram

```
┌─────────────────────────────────────────┐
│            Material App (GetX)          │
├─────────────────────────────────────────┤
│                Routes                   │
│  /: SplashPage | /home: HomeView       │
├─────────────────────────────────────────┤
│           Feature Modules                │
│  ┌──────────────────────────────────┐  │
│  │ Splash │ Login │ SignUp │ Home │  │
│  │ History │ (MVC structure)       │  │
│  └──────────────────────────────────┘  │
├─────────────────────────────────────────┤
│          Core Services Layer             │
│  ObjectBox │ API │ LocalStorage │ UI    │
├─────────────────────────────────────────┤
│             Config & Constants          │
│  Theme │ Endpoints │ Assets             │
└─────────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── main.dart                  # Entry point, app initialization
├── config/
│   ├── theme/                 # App theming (colors, text styles)
│   └── config.dart
├── constants/
│   ├── endpoints.dart         # API endpoints
│   ├── app_constants.dart
│   ├── asset_paths.dart
│   └── dummy_response.dart
├── modules/                   # Feature modules (MVC)
│   ├── splash/               # Splash screen flow
│   ├── login/                # User authentication
│   ├── sign_up/              # Registration flow
│   ├── home/                 # Pomodoro timer main screen
│   └── history/              # Activity history
├── utils/
│   ├── services/             # Local services (ObjectBox, storage)
│   ├── network/              # API communication layer
│   ├── models/               # Shared data models
│   ├── enums/                # App enums
│   ├── helpers/              # Extension methods
│   └── ui/                   # Reusable UI components
└── objectbox-model.json       # ObjectBox schema
```

---

## Key Concepts

### 1. **Module Structure (MVC Pattern)**
Each feature module follows:
- **View** - UI/Widgets (GetBuilder, Stateless)
- **Controller** - GetXController (state, business logic)
- **Repository** - Data operations (API, local storage)
- **Model** - Data classes

### 2. **State Management (GetX)**
- Controllers extend `GetxController`
- `Get.put()` for dependency registration
- `GetBuilder<>` for UI rebuilding
- `update()` for notifying listeners

### 3. **Data Persistence**
- **ObjectBox** - Local object storage for history
- **SharedPreferences** - Key-value pairs
- **API** - Remote data via HTTP

### 4. **Responsive Design**
- Uses `Sizer` package for responsive sizing
- `SizedBox`, `ResponsiveWidget` patterns
- Supports portrait orientation (locked)

---

## Navigation Flow

```
SplashPage
    ↓
LoginView or HomeView (based on auth state)
    ↓
HomeView (Pomodoro timer)
    ├─ HistoryView (drawer menu)
    └─ LoginView (sign out)
```

---

## Development Quick Reference

### Run Application
```bash
flutter pub get
flutter run
```

### Generate ObjectBox Models
```bash
flutter pub run build_runner build
```

### Build APK
```bash
flutter build apk --release
```

### Run Tests
```bash
flutter test
```

---

## Contact & Documentation

For detailed documentation on specific areas, see the linked codemap files above.

Last generated: **2026-04-17 (rev 2)**
