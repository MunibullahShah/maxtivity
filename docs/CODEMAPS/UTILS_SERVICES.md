# Utils & Services Codemap

**Last Updated:** 2026-04-17

## Overview

The utils layer provides shared services, networking infrastructure, helpers, and reusable functionality used across all modules.

---

## Directory Structure

```
utils/
├── network/              # API communication layer
│   ├── backend_calls.dart
│   ├── backend_repository.dart
│   └── general_api_state.dart
├── services/             # Core services (singleton)
│   ├── object_box.dart
│   ├── local_storage_service.dart
│   ├── date_picker_service.dart
│   ├── image_picker_service.dart
│   └── [services]
├── ui/                   # Reusable UI components
│   ├── buttons/
│   ├── textfields/
│   ├── dialogs/
│   ├── drop_down/
│   ├── date_time_widget/
│   ├── appbar/
│   ├── drawer/
│   └── [widgets]
├── models/               # Shared data models
│   └── user_model.dart
├── enums/               # Enumeration types
│   └── enums.dart
├── helpers/             # Extension methods
│   └── extensions.dart
└── utils.dart           # Main export file
```

---

## Network Layer

### general_api_state.dart

Defines API response handling and state management.

```dart
enum ApiState {
  INITIAL,    // Initial state
  LOADING,    // API call in progress
  LOADED,     // Data successfully loaded
  ERROR,      // Error occurred
}

class ApiResponse<T> {
  final ApiState apiState;
  final T? data;
  final String? message;
  final int? statusCode;
  
  ApiResponse({
    required this.apiState,
    this.data,
    this.message,
    this.statusCode,
  });
  
  factory ApiResponse.initial() => ApiResponse(apiState: ApiState.INITIAL);
  factory ApiResponse.loading() => ApiResponse(apiState: ApiState.LOADING);
  factory ApiResponse.completed(T data) => ApiResponse(
    apiState: ApiState.LOADED,
    data: data,
  );
  factory ApiResponse.error(String message, int? statusCode) => ApiResponse(
    apiState: ApiState.ERROR,
    message: message,
    statusCode: statusCode,
  );
}
```

### backend_calls.dart

Low-level HTTP operations.

```dart
class BackendCalls {
  static const String baseUrl = AppConstants.baseUrl;
  static const Duration timeout = Duration(seconds: 30);
  
  // GET request
  static Future<ApiResponse<T>> getRequest<T>(
    String endpoint, {
    required T Function(dynamic) onSuccess,
    Map<String, String>? headers,
  });
  
  // POST request
  static Future<ApiResponse<T>> postRequest<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    required T Function(dynamic) onSuccess,
    Map<String, String>? headers,
  });
  
  // PUT request
  static Future<ApiResponse<T>> putRequest<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    required T Function(dynamic) onSuccess,
  });
  
  // DELETE request
  static Future<ApiResponse<T>> deleteRequest<T>(
    String endpoint,
    T Function(dynamic) onSuccess,
  );
  
  // Handle common errors
  static ApiResponse<T> _handleError(dynamic error, StackTrace stackTrace);
}
```

### backend_repository.dart

High-level API wrapper.

```dart
class BackendRepository {
  final BackendCalls _backendCalls;
  
  // Authentication endpoints
  Future<ApiResponse<LoginModel>> loginUser(
    String email,
    String password,
  );
  
  Future<ApiResponse<LoginModel>> registerUser({
    required String fullName,
    required String email,
    required String password,
  });
  
  Future<ApiResponse<UserModel>> getUserProfile(String userId);
  Future<ApiResponse<void>> logoutUser();
  
  // Session endpoints
  Future<ApiResponse<HistoryModel>> createSession(
    HistoryModel session,
  );
  
  Future<ApiResponse<List<HistoryModel>>> getUserSessions(String userId);
  
  Future<ApiResponse<void>> deleteSession(String sessionId);
  
  // Error handling
  Future<ApiResponse<T>> _safeApiCall<T>(
    Future<ApiResponse<T>> Function() call,
  );
}
```

---

## Services Layer

### ObjectBox Service (object_box.dart)

Local object database for offline storage.

```dart
class ObjectBox {
  late final Store _store;
  
  // Entity boxes
  late final Box<UserModel> userBox;
  late final Box<HistoryModel> historyBox;
  
  // Singleton factory
  static ObjectBox? _instance;
  
  // Initialize
  static Future<ObjectBox> create() async {
    if (_instance != null) return _instance!;
    
    final store = await openStore();
    _instance = ObjectBox._(store);
    return _instance!;
  }
  
  // User operations
  int addUser(UserModel user);
  UserModel? getUser(int id);
  List<UserModel> getAllUsers();
  void updateUser(UserModel user);
  void deleteUser(int id);
  
  // History operations
  int addHistory(HistoryModel history);
  List<HistoryModel> getHistoryByUser(String userId);
  List<HistoryModel> getHistoryByDateRange(DateTime start, DateTime end);
  void updateHistory(HistoryModel history);
  void deleteHistory(int id);
  
  void close();
}
```

**Global Access:**
```dart
// In main.dart:
late ObjectBox objectBox;

// Usage anywhere:
objectBox.historyBox.getAll();
objectBox.userBox.query().build().find();
```

### LocalStorageService (local_storage_service.dart)

SharedPreferences wrapper for key-value storage.

```dart
class LocalStorageService {
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _rememberMeKey = 'remember_me';
  
  // Token management
  static Future<bool> saveToken(String token);
  static Future<String?> getToken();
  static Future<bool> clearToken();
  
  // User preferences
  static Future<bool> saveUserId(String userId);
  static Future<String?> getUserId();
  
  static Future<bool> saveUserEmail(String email);
  static Future<String?> getUserEmail();
  
  static Future<bool> setRememberMe(bool value);
  static Future<bool?> getRememberMe();
  
  // Clear all
  static Future<bool> clearAll();
}
```

### DatePickerService (date_picker_service.dart)

Wrapper for date/time selection.

```dart
class DatePickerService {
  // Pick single date
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  });
  
  // Pick date range
  static Future<DateTimeRange?> pickDateRange(
    BuildContext context, {
    DateTime? firstDate,
    DateTime? lastDate,
  });
  
  // Pick time
  static Future<TimeOfDay?> pickTime(BuildContext context);
}
```

### ImagePickerService (image_picker_service.dart)

Wrapper for image selection.

```dart
class ImagePickerService {
  // Pick from gallery
  static Future<File?> pickImageFromGallery({
    ImageSource source = ImageSource.gallery,
  });
  
  // Pick from camera
  static Future<File?> pickImageFromCamera({
    ImageSource source = ImageSource.camera,
  });
  
  // Multiple images
  static Future<List<XFile>?> pickMultipleImages();
  
  // Crop image
  static Future<File?> cropImage(File imageFile);
}
```

---

## Helpers

### extensions.dart

Dart extension methods for common operations.

```dart
// String extensions
extension StringExtension on String {
  bool get isEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  ).hasMatch(this);
  
  bool get isStrongPassword => length >= 8 &&
    contains(RegExp(r'[A-Z]')) &&
    contains(RegExp(r'[0-9]')) &&
    contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  
  String get capitalized => 
    isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  
  DateTime? toDateTime() => DateTime.tryParse(this);
}

// DateTime extensions
extension DateTimeExtension on DateTime {
  bool isToday => 
    year == DateTime.now().year &&
    month == DateTime.now().month &&
    day == DateTime.now().day;
  
  bool isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year &&
      month == yesterday.month &&
      day == yesterday.day;
  }
  
  String toFormattedString() => 
    '$day-$month-$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  
  int get daysDifference => 
    difference(DateTime(year, month, day)).inDays;
}

// List extensions
extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
  
  List<T> unique({required T Function(T) key}) {
    final seen = <dynamic>{};
    return where((element) => seen.add(key(element))).toList();
  }
}

// Context extensions
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
}
```

---

## Enums

### enums.dart

```dart
enum TimerState {
  idle,
  running,
  paused,
  completed,
}

enum SessionCategory {
  work,
  personal,
  learning,
  exercise,
  other,
}

enum ApiErrorType {
  networkError,
  serverError,
  validationError,
  authenticationError,
  authorizationError,
  notFoundError,
  unknownError,
}

enum UserRole {
  user,
  admin,
  moderator,
}
```

---

## Shared Models

### user_model.dart

```dart
@Entity()
class UserModel extends Equatable {
  @Id()
  int id = 0;
  
  late String userId;        // Unique string ID
  late String email;
  late String fullName;
  late String profileImage;
  late DateTime createdAt;
  late DateTime updatedAt;
  String? phoneNumber;
  String? bio;
  
  UserModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.bio,
  });
  
  @override
  List<Object?> get props => [
    userId,
    email,
    fullName,
    createdAt,
  ];
}
```

---

## API Endpoints

### constants/endpoints.dart

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  
  // Authentication
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String logout = '/api/v1/auth/logout';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String userProfile = '/api/v1/users/profile';
  
  // Sessions
  static const String createSession = '/api/v1/sessions';
  static const String getUserSessions = '/api/v1/users/{userId}/sessions';
  static const String updateSession = '/api/v1/sessions/{id}';
  static const String deleteSession = '/api/v1/sessions/{id}';
  
  // History
  static const String getHistory = '/api/v1/users/{userId}/history';
  static const String getHistoryStats = '/api/v1/users/{userId}/stats';
}
```

---

## Error Handling Pattern

### Standard Error Response

```dart
// All repositories follow this pattern:
Future<ApiResponse<T>> someOperation() async {
  try {
    final response = await backendRepository.callApi();
    if (response.apiState == ApiState.LOADED) {
      // Process data
      return ApiResponse.completed(processedData);
    } else {
      return ApiResponse.error(
        response.message ?? 'Unknown error',
        response.statusCode,
      );
    }
  } catch (e, stackTrace) {
    return ApiResponse.error(
      'Failed to perform operation: $e',
      null,
    );
  }
}
```

### Controller Error Display

```dart
// In controller:
Future<void> someAction() async {
  isLoading = true;
  update();
  
  final result = await repository.someOperation();
  
  if (result.apiState == ApiState.LOADED) {
    // Success
    data = result.data;
  } else {
    // Error
    errorMessage = result.message;
    ShowSnackBar.show(
      message: errorMessage ?? 'An error occurred',
      backgroundColor: Colors.red,
    );
  }
  
  isLoading = false;
  update();
}
```

---

## Service Usage Examples

### Saving Session to ObjectBox
```dart
final history = HistoryModel(
  userId: currentUserId,
  durationMinutes: 25,
  startTime: DateTime.now(),
  endTime: DateTime.now().add(Duration(minutes: 25)),
  isCompleted: true,
);

objectBox.historyBox.put(history);
```

### Retrieving User Sessions
```dart
final sessions = objectBox.historyBox
  .query(HistoryModel_.userId.equals(userId))
  .order(HistoryModel_.startTime, flags: Order.descending)
  .build()
  .find();
```

### Saving Authentication Token
```dart
await LocalStorageService.saveToken(loginResponse.token);
await LocalStorageService.saveUserId(loginResponse.userId);
```

### Picking and Uploading Image
```dart
final imageFile = await ImagePickerService.pickImageFromGallery();
if (imageFile != null) {
  // Upload to server
  final result = await repository.uploadProfileImage(imageFile);
}
```

---

See also:
- [APP_ARCHITECTURE.md](APP_ARCHITECTURE.md) for overall structure
- [DATA_LAYER.md](DATA_LAYER.md) for data models
- [UI_COMPONENTS.md](UI_COMPONENTS.md) for UI widgets
