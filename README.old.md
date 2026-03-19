# Demo Project — Production-Ready Flutter MVC Boilerplate

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-red.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Architecture](https://img.shields.io/badge/Architecture-MVC-9cf.svg)]()

**A scalable, production-ready Flutter boilerplate leveraging MVC architecture with GetX**

[Getting Started](#getting-started) • [Features](#features) • [Architecture](#architecture) • [Documentation](#documentation) • [Contributing](#contributing)

</div>

---

## 🌟 Features

### Core Architecture
- **MVC Pattern** — Clean separation of Model, View, and Controller
- **GetX Framework** — State management, routing, and dependency injection
- **BaseController** — Pre-built `apiCall<T>()` wrapper eliminates boilerplate error/loading/retry logic
- **Streamlined Bindings** — Automatic controller lifecycle management

### Network & API
- **BaseApiService** — Singleton HTTP client with automatic token injection
- **Typed Exceptions** — `ApiException` for consistent error handling
- **Response Wrapper** — `ApiResponse<T>` for predictable API structure
- **Connectivity Checks** — Offline detection with automatic retry prompts
- **Error Parsing** — Centralized error formatting for UI display

### UI & UX
- **Global Loading Overlay** — App-wide loading state (prevents duplicate overlays)
- **Centralized Validators** — `BaseValidator` with email, phone, password, length checks
- **Error Widgets** — Pre-built full-screen error, empty state, and offline screens
- **Responsive Utilities** — Mobile/tablet detection helpers

### Data Persistence
- **SharedPreferences Wrapper** — Type-safe local storage singleton
- **Session Management** — Automatic token persistence and retrieval
- **Theme Persistence** — Light/dark mode preference saving
- **Language Persistence** — Selected language data restoration on app restart

### Theming & Internationalization
- **Light/Dark Theme Switching** — Persisted user preference
- **Multi-Language Support** — 4+ languages (English, Arabic, Spanish, French) with dialog selector
- **RTL Support** — Full Arabic/RTL layout compatibility
- **Dynamic Language Selection Dialog** — User-friendly language picker

### Security & Administration
- **Route Guards** — `AuthMiddleware` for protected routes
- **Token Management** — Secure token injection in API headers
- **Environment Config** — Dev/Staging/Prod environment switching
- **Pagination Pattern** — Scalable inline pagination (no heavy base classes)

---

## 📁 Project Architecture

### Folder Structure

```
lib/
├── main.dart                                      # App entry point, theme, localization setup
└── app/
    ├── routes/
    │   ├── app_routes.dart                        # Named route constants (login, userList)
    │   ├── app_pages.dart                         # GetPage list with bindings & middlewares
    │   └── auth_middleware.dart                   # Route guard (checks token validity)
    │
    ├── core/                                      # Shared utilities & services
    │   ├── config/
    │   │   └── environment.dart                   # Dev/Staging/Prod base URLs
    │   │
    │   ├── network/
    │   │   ├── api_endpoints.dart                 # Endpoint path constants
    │   │   ├── api_exception.dart                 # Typed API exception with status codes
    │   │   ├── api_response.dart                  # Generic response wrapper <T>
    │   │   ├── connectivity_service.dart          # Network connectivity checker
    │   │   └── base_api_service.dart              # Singleton HTTP client
    │   │
    │   ├── storage/
    │   │   ├── storage_keys.dart                  # SharedPreferences key constants
    │   │   └── storage_service.dart               # Typed SharedPreferences wrapper
    │   │
    │   ├── theme/
    │   │   ├── app_colors.dart                    # Color palette (dark/light)
    │   │   ├── app_theme.dart                     # ThemeData for GetMaterialApp
    │   │   └── theme_controller.dart              # Theme toggle controller (persisted)
    │   │
    │   ├── localization/
    │   │   ├── app_translations.dart              # GetX Translations map
    │   │   ├── localization_controller.dart       # Language switcher (persisted)
    │   │   ├── language_selection.dart            # Dialog & BottomSheet widgets
    │   │   └── languages/
    │   │       ├── en_us.dart                     # English strings
    │   │       ├── ar_sa.dart                     # Arabic strings (RTL)
    │   │       ├── es_es.dart                     # Spanish strings
    │   │       └── fr_fr.dart                     # French strings
    │   │
    │   ├── global/
    │   │   ├── loading_controller.dart            # Global loading state manager
    │   │   ├── loading_overlay.dart               # Overlay widget with AbsorbPointer
    │   │   └── global_bindings.dart               # Permanent controller init
    │   │
    │   ├── error/
    │   │   └── error_handler.dart                 # Snackbar/Dialog error display
    │   │
    │   ├── base/
    │   │   └── base_controller.dart               # Abstract base with apiCall<T>()
    │   │
    │   ├── validation/
    │   │   └── base_validator.dart                # Static form validators
    │   │
    │   ├── utils/
    │   │   ├── logger.dart                        # Dev-mode logger
    │   │   ├── responsive.dart                    # Mobile/tablet helper
    │   │   └── constants/
    │   │       └── app_constants.dart             # App-wide constants
    │   │
    │   └── constants/
    │       └── app_constants.dart                 # Global constants (pagination, etc)
    │
    ├── shared/                                    # App-wide shared widgets
    │   └── widgets/
    │       ├── error_widget.dart                  # Full-screen error display
    │       ├── no_internet_widget.dart            # No connection screen
    │       ├── loading_widget.dart                # Centered spinner widget
    │       └── empty_widget.dart                  # Empty state display
    │
    └── features/                                  # Feature modules
        ├── login/
        │   ├── model/
        │   │   ├── login_request.dart             # Login request DTO
        │   │   └── login_response.dart            # Login response DTO with token
        │   ├── controller/
        │   │   └── login_controller.dart          # Login logic & validation
        │   ├── binding/
        │   │   └── login_binding.dart             # GetX dependency binding
        │   └── view/
        │       └── login_page.dart                # Login UI (StatelessWidget)
        │
        └── user_list/
            ├── model/
            │   └── user_model.dart                # User data model with JSON serialization
            ├── controller/
            │   └── user_list_controller.dart      # List with inline pagination
            ├── binding/
            │   └── user_list_binding.dart         # GetX dependency binding
            └── view/
                ├── user_list_page.dart            # List UI with pull-to-refresh
                └── widgets/
                    └── user_tile.dart             # User list item widget
```

### Architecture Pattern: MVC

```
View (UI Layer)                Controller (Logic Layer)         Model (Data Layer)
────────────────               ──────────────────────           ──────────────────
LoginPage                  →   LoginController            →    LoginRequest
(StatelessWidget)              (extends BaseController)        LoginResponse
- TextField inputs             - Validation logic              (JSON serializable)
- Form submission              - API call wrapper
- Error display                - State management (Rx)
- Theme toggle
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter** 3.10+
- **Dart** 3.0+
- A code editor (VS Code, Android Studio, or Xcode)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd demo_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Analyze code**
   ```bash
   flutter analyze
   ```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `get` | ^4.7.2 | State management, routing, DI, snackbars, translations |
| `http` | ^1.3.0 | HTTP requests (GET, POST, etc.) |
| `shared_preferences` | ^2.3.0 | Persistent local key-value storage |
| `connectivity_plus` | ^6.1.4 | Network connectivity detection |

---

## 📖 Usage & Examples

### 1️⃣ Working with Controllers — `apiCall<T>()`

Every controller extends `BaseController`, providing the `apiCall<T>()` method that wraps API calls with automatic loading, error handling, and retry logic:

```dart
class LoginController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    // apiCall() handles: loading overlay, parsing, error display, retry
    final result = await apiCall<LoginResponse>(
      () async {
        final request = LoginRequest(
          email: emailController.text,
          password: passwordController.text,
        );
        final response = await _api.post(
          ApiEndpoints.login,
          body: request.toJson(),
        );
        return LoginResponse.fromJson(response);
      },
      showOverlay: true,  // Global loading overlay
    );

    if (result != null) {
      // Save token and navigate
      await _storage.saveToken(result.token);
      Get.offAllNamed(AppRoutes.userList);
    }
  }
}
```

**Options:**
- `showOverlay` — Show global loading overlay
- `showLoading` — Show local loading state
- `handleError` — Catch specific errors
- `onError` — Custom error callback

### 2️⃣ Storage Service — Type-Safe Persistence

Initialize once in `main()`, then use synchronously:

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();  // Initialize SharedPreferences
  runApp(const MyApp());
}

// ANY screen/controller
final storage = StorageService();

// Token management
await storage.saveToken('abc123xyz...');
String? token = storage.getToken();
await storage.removeToken();

// Theme persistence
await storage.saveThemeMode(true);  // dark mode
bool isDark = storage.getThemeMode();

// Language persistence
await storage.saveLanguageCode('ar_SA');
String? lang = storage.getLanguageCode();

// Auth state
bool isLoggedIn = storage.isLoggedIn;
```

### 3️⃣ Global Loading Overlay

Control app-wide loading state from any controller:

```dart
// The overlay wraps the app in main.dart:
GetMaterialApp(
  builder: (context, child) => LoadingOverlay(
    child: child ?? const SizedBox.shrink(),
  ),
  // ... other config
)

// Show overlay from any controller
Future<void> fetchData() async {
  await apiCall<Data>(
    () => _api.get(ApiEndpoints.data),
    showOverlay: true,  // Shows AbsorbPointer overlay
  );
}

// Manual control
Get.find<LoadingController>().show();
Get.find<LoadingController>().hide();
```

### 4️⃣ Form Validation with BaseValidator

Use centralized validators across your app:

```dart
TextFormField(
  controller: emailController,
  validator: BaseValidator.validateEmail,  // Built-in email regex
  decoration: InputDecoration(
    labelText: 'email'.tr,
    prefixIcon: const Icon(Icons.email_outlined),
  ),
),
TextFormField(
  controller: passwordController,
  obscureText: true,
  validator: BaseValidator.validatePassword,  // Min 8 chars, uppercase, digit
  decoration: InputDecoration(
    labelText: 'password'.tr,
    prefixIcon: const Icon(Icons.lock_outlined),
  ),
),
TextFormField(
  validator: (value) => BaseValidator.validateRequired(value, 'Username'),
),
TextFormField(
  validator: (value) => BaseValidator.validateMinLength(value, 3, 'Name'),
),
TextFormField(
  validator: (value) => BaseValidator.validateMatch(
    value,
    passwordController.text,
    'Passwords do not match',
  ),
),
```

**Available Validators:**
- `validateEmail(String?)` — RFC 5322 email format
- `validatePassword(String?)` — Min 8 chars, uppercase, digit
- `validateRequired(String?, String)` — Not empty
- `validatePhone(String?)` — 10-digit phone
- `validateMinLength(String?, int, String)` — Min character length
- `validateMatch(String?, String, String)` — Two fields match

### 5️⃣ Pagination with Inline Pattern

Controllers manage their own RxList and pagination state:

```dart
class UserListController extends BaseController {
  final users = <UserModel>[].obs;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;
  
  int _currentPage = 1;
  static const _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    _currentPage = 1;
    hasMore.value = true;
    users.clear();
    
    final result = await apiCall<List<UserModel>>(
      () => _api.get(ApiEndpoints.users, queryParameters: {
        'page': _currentPage,
        'limit': _pageSize,
      }),
      showLoading: true,
    );
    
    if (result != null) {
      users.addAll(result);
      hasMore.value = result.length >= _pageSize;
      _currentPage++;
    }
  }

  Future<void> loadMoreUsers() async {
    if (!hasMore.value || isLoadingMore.value) return;
    
    isLoadingMore.value = true;
    final result = await apiCall<List<UserModel>>(
      () => _api.get(ApiEndpoints.users, queryParameters: {
        'page': _currentPage,
        'limit': _pageSize,
      }),
      showLoading: false,
    );
    
    if (result != null) {
      users.addAll(result);
      hasMore.value = result.length >= _pageSize;
      _currentPage++;
    }
    isLoadingMore.value = false;
  }
}
```

### 6️⃣ Theming — Light/Dark Mode

Toggle theme and persist preference from any screen:

```dart
// In any controller or widget
final themeController = Get.find<ThemeController>();

// Toggle between light and dark
themeController.toggleTheme();

// Access current state
if (themeController.isDarkMode.value) {
  // Dark mode is active
}

// AppBar example with theme toggle
AppBar(
  title: Text('login'.tr),
  actions: [
    IconButton(
      icon: Obx(() => Icon(
        themeController.isDarkMode.value
            ? Icons.light_mode
            : Icons.dark_mode,
      )),
      onPressed: themeController.toggleTheme,
    ),
  ],
)
```

### 7️⃣ Multi-Language Support with Selection Dialog

Switch languages dynamically with a beautiful dialog picker:

```dart
// Access localization controller
final locController = Get.find<LocalizationController>();

// Show language selection dialog
IconButton(
  icon: const Icon(Icons.language),
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => const LanguageSelectionDialog(),
    );
  },
)

// Alternative: Show as bottom sheet
showModalBottomSheet(
  context: context,
  builder: (context) => const LanguageSelectionBottomSheet(),
)

// Manual language switch
locController.changeLanguage(LanguageInfo(
  code: 'es',
  country: 'ES',
  name: 'Spanish',
  nativeName: 'Español',
));

// Use translations in UI
Text('login'.tr)  // Automatically translates based on current locale
```

**Supported Languages:**
- 🇺🇸 English (en_US)
- 🇸🇦 Arabic (ar_SA) — Full RTL support
- 🇪🇸 Spanish (es_ES)
- 🇫🇷 French (fr_FR)

### 8️⃣ Routing & Navigation

Define routes and navigate between screens:

```dart
// app_routes.dart — Define route constants
class AppRoutes {
  static const String login = '/login';
  static const String userList = '/user-list';
}

// app_pages.dart — Register pages with bindings
static final pages = <GetPage>[
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginPage(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: AppRoutes.userList,
    page: () => const UserListPage(),
    binding: UserListBinding(),
    middlewares: [AuthMiddleware()],  // Protected route
  ),
];

// Navigate from any controller
Get.toNamed(AppRoutes.userList);           // Push
Get.offNamed(AppRoutes.userList);          // Replace
Get.offAllNamed(AppRoutes.login);          // Clear stack

// Navigate with arguments
Get.toNamed(AppRoutes.userList, arguments: userId);
```

### 9️⃣ API Service with Token Injection

Centralized HTTP client with automatic token injection:

```dart
// In any controller extending BaseController
final result = await apiCall<UserList>(
  () => _api.get(ApiEndpoints.users),
  showOverlay: true,
);

// BaseApiService automatically:
// 1. Adds auth token to headers
// 2. Checks internet connectivity
// 3. Parses and types responses
// 4. Throws typed ApiException on errors
```

### 🔟 Error Handling

Centralized error display across the app:

```dart
// Errors automatically display as:
// - Snackbar for API errors
// - Dialog for critical errors
// - Retry button for network errors

final result = await apiCall<Data>(
  () => fetchData(),
  showOverlay: true,
  handleError: (error) {
    if (error is ApiException) {
      if (error.statusCode == 401) {
        // Handle unauthorized
        Get.offAllNamed(AppRoutes.login);
      }
    }
  },
);
```

---

## 🔐 Security Best Practices

1. **Token Management** — Store tokens in `storage_service.dart`
2. **Protected Routes** — Use `AuthMiddleware` for sensitive screens
3. **Secure Headers** — Add auth token via `BaseApiService`
4. **Environment Config** — Use `environment.dart` for API URLs
5. **Error Messages** — Never expose sensitive data in errors

---

## 🧪 Testing & Validations

```bash
# Analyze code for issues
flutter analyze

# Run tests (add test files to test/)
flutter test

# Build for production
flutter build apk     # Android
flutter build ios     # iOS
flutter build web     # Web
flutter build windows # Windows
```

---

## 📝 Adding a New Language

1. Create translation file: `lib/app/core/localization/languages/xx_yy.dart`
   ```dart
   const Map<String, String> xxYy = {
     'login': '...',
     'email': '...',
     // ... all keys
   };
   ```

2. Update `app_translations.dart`
   ```dart
   import 'languages/xx_yy.dart';
   
   Map<String, Map<String, String>> get keys => {
     // ...existing...
     'xx_YY': xxYy,
   };
   ```

3. Update `localization_controller.dart` availableLanguages list

---

## 🛠️ Common Tasks

### Modify API Endpoints
Edit `lib/app/core/network/api_endpoints.dart`

### Add Storage Keys
Update `lib/app/core/storage/storage_keys.dart`

### Change Theme Colors
Update `lib/app/core/theme/app_colors.dart`

### Switch Environments
Modify `environment` in `main.dart` to Dev/Staging/Prod

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m "Add amazing feature"`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 📧 Support & Questions

For issues, questions, or suggestions, please open an issue on GitHub or contact the development team.

**Happy coding! 🚀**
- **ErrorHandler is static** — fire-and-forget side effects, no reactive state
- **LoadingOverlay** wraps the entire app — any controller can trigger it via `apiCall(showOverlay: true)` or directly via `LoadingController`

## Recommended Workflow

1. **Create a new feature folder** under `lib/app/features/your_feature/`
2. **Add model** — request/response DTOs with `fromJson` / `toJson`
3. **Add controller** — extend `BaseController`, use `apiCall<T>()` for API calls
4. **Add binding** — register controller with `Get.lazyPut`
5. **Add view** — `StatelessWidget` with `Get.put(Controller())` and `Obx()` for reactive UI
6. **Register route** — add constant in `app_routes.dart`, add `GetPage` in `app_pages.dart`
7. **Add API endpoints** — register paths in `api_endpoints.dart`
8. **Add translations** — add keys to `en_us.dart` and `ar_sa.dart`

## References

- [GetX Documentation](https://pub.dev/packages/get)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [HTTP Package](https://pub.dev/packages/http)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)
- [Flutter Official Docs](https://docs.flutter.dev/)
