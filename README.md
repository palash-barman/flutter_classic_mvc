# ?? Demo Project — Production-Ready Flutter MVC Architecture

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-red.svg)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-4.7.2-green.svg)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Architecture](https://img.shields.io/badge/Architecture-Classic%20MVC-orange.svg)]()

**Scalable, maintainable Flutter boilerplate for 300+ projects & 300+ developers**

[Quick Start](#quick-start) • [Architecture](#architecture) • [Features](#features) • [Project Structure](#project-structure) • [Contributing](#contributing) • [Documentation](#documentation)

</div>

---

## ? Why This Project?

? **Production Ready** — Battle-tested MVC pattern with GetX  
? **Scalable** — Supports 300+ parallel projects, 30-60 day sprints  
? **Zero Code Issues** — `flutter analyze` passes with 0 issues  
? **Developer Friendly** — Simple, flat structure without over-engineering  
? **Well Documented** — ARCHITECTURE.md, SETUP.md, CONTRIBUTING.md included  
? **Rapid Development** — Pre-built utilities, helpers, and patterns  

---

## ?? Quick Start

### Prerequisites
```bash
flutter --version         # 3.10.0 or higher
dart --version           # 3.0.0 or higher
```

### Installation

```bash
# 1. Clone repository
git clone <repository-url>
cd demo_project

# 2. Get dependencies
flutter pub get

# 3. Run app
flutter run
```

### Quick Test
```bash
# Check code quality (should be 0 issues)
flutter analyze --no-pub

# Run tests
flutter test

# Generate build
flutter build apk
```

---

## ?? Architecture Overview

### MVC Pattern (Classic)

```
Request Flow:
+-------------+
¦   UI View   ¦  ? User interaction (tap, input)
+-------------+
       ¦
       ?
+----------------------+
¦ Controller (GetX)    ¦  ? Business logic, state management
+----------------------+
       ¦
       ?
+----------------------+
¦ Services             ¦  ? API calls, storage, connectivity
+----------------------+
       ¦
       ?
+----------------------+
¦ Models               ¦  ? Data classes, serialization
+----------------------+
```

### Key Concepts

| Layer | Responsibility | Example |
|-------|-----------------|---------|
| **View** | UI, user interaction | `LoginPage`, `ProductsPage` |
| **Controller** | State management, API calls | `LoginController.login()` |
| **Service** | External dependencies | `ApiService.post()`, `StorageService.saveToken()` |
| **Model** | Data classes, serialization | `ProductModel`, `LoginResponse` |

---

## ?? Project Structure

```
lib/
+-- main.dart                          # App entry point (GetMaterialApp config)
¦
+-- controllers/                       # Business logic & state management
¦   +-- login_controller.dart          # Authentication logic  
¦   +-- products_controller.dart       # Product list with pagination
¦
+-- models/                            # Data classes & DTOs
¦   +-- login_response.dart            # Auth response wrapper
¦   +-- product_model.dart             # Product entity
¦   +-- login_request.dart             # Login request DTO
¦
+-- views/                             # UI Pages (Screens)
¦   +-- login_page.dart                # Login form with validation
¦   +-- products_page.dart             # Product list with infinite scroll
¦
+-- widgets/                           # Reusable UI components
¦   +-- loading_widget.dart            # Centered progress indicator
¦   +-- error_widget.dart              # Error screen with retry
¦   +-- empty_widget.dart              # Empty state display
¦   +-- no_internet_widget.dart        # Offline state display
¦   +-- product_card.dart              # Product list item
¦
+-- services/                          # External dependencies & APIs
¦   +-- api_service.dart               # HTTP client (singleton)
¦   +-- api_endpoints.dart             # Endpoint constants
¦   +-- api_exception.dart             # Custom exception class
¦   +-- connectivity_service.dart      # Network status detection
¦   +-- storage_service.dart           # SharedPreferences wrapper
¦
+-- routes/                            # Navigation & routing
¦   +-- app_routes.dart                # Named route constants
¦   +-- app_pages.dart                 # GetPage configuration
¦   +-- auth_middleware.dart           # Route guards
¦
+-- core/                              # Shared utilities & configuration
    +-- config/
    ¦   +-- environment.dart           # Environment settings (dev/prod)
    ¦
    +-- constants/
    ¦   +-- app_constants.dart         # App-wide constants
    ¦
    +-- theme/
    ¦   +-- app_theme.dart             # Material theme definitions
    ¦   +-- app_colors.dart            # Color palette
    ¦   +-- theme_controller.dart      # Dark/light mode toggle
    ¦
    +-- localization/
    ¦   +-- app_translations.dart      # Language strings
    ¦   +-- localization_controller.dart
    ¦   +-- languages/
    ¦       +-- en_us.dart             # English translations
    ¦       +-- ar_sa.dart             # Arabic translations
    ¦       +-- es_es.dart             # Spanish translations
    ¦       +-- fr_fr.dart             # French translations
    ¦
    +-- global/
    ¦   +-- global_bindings.dart       # GetX initial bindings
    ¦   +-- loading_controller.dart    # Global loading state
    ¦   +-- loading_overlay.dart       # App-wide loading widget
    ¦
    +-- utils/
    ¦   +-- logger.dart                # Debug logging utility
    ¦   +-- responsive.dart            # Responsive design helpers
    ¦   +-- app_validator.dart         # Input validation methods
    ¦
    +-- error/
    ¦   +-- error_handler.dart         # Error display utility
    ¦
    +-- base/
        +-- base_controller.dart       # Base controller with utilities
```

---

## ?? Key Features

### 1. **Clean MVC Architecture**
- Controllers handle only business logic
- Views are simple, stateless widgets
- Services manage external dependencies
- Models are pure data classes

### 2. **State Management with GetX**
```dart
// Reactive state
final isLoading = false.obs;
final items = <Item>[].obs;

// Auto UI updates
Obx(() => isLoading.value ? LoadingWidget() : ListView())
```

### 3. **Automatic API Error Handling**
```dart
// In controller
try {
  final response = await apiService.get(endpoint);
} catch (e) {
  errorMessage.value = e.toString();
  hasError.value = true;
}
```

### 4. **Type-Safe Form Validation**
```dart
// Use built-in validators
String? email = AppValidator.validateEmail(input);
String? password = AppValidator.validatePassword(input);
```

### 5. **Persistent Storage**
```dart
await StorageService().saveToken(token);
String? token = StorageService().getToken();
```

### 6. **Global Loading State**
```dart
// App-wide loading overlay (prevents multiple overlays)
if (isLoading.value) {
  return const LoadingWidget();
}
```

### 7. **Multi-Language Support**
```dart
// Get localized string
Text('hello'.tr)  // English: "Hello", Arabic: "?????"

// Change language
Get.find<LocalizationController>().changeLanguage('ar');
```

### 8. **Dark/Light Theme**
```dart
// Toggle theme
Get.find<ThemeController>().toggleTheme();

// Use theme colors
color: context.theme.primary
```

### 9. **Protected Routes**
```dart
// AuthMiddleware checks token before accessing product page
GetPage(
  name: AppRoutes.products,
  page: () => ProductsPage(),
  middlewares: [AuthMiddleware()],
)
```

### 10. **Connectivity Detection**
```dart
// Check internet connection
bool hasInternet = await ConnectivityService().hasConnection;

// Show offline widget if needed
if (!hasInternet) {
  return const NoInternetWidget();
}
```

---

## ?? Services Usage

### API Service
```dart
final apiService = ApiService();

// GET
final data = await apiService.get('/products', queryParams: {'page': 1});

// POST
final response = await apiService.post('/login', body: loginData);

// PUT/DELETE
await apiService.put('/products/1', body: updateData);
await apiService.delete('/products/1');
```

### Storage Service
```dart
// Initialize (in main.dart)
await StorageService.init();

// Save/Get data
await StorageService().saveToken('token123');
String? token = StorageService().getToken();

await StorageService().saveThemeMode(true);
bool isDarkMode = StorageService().getThemeMode();

// Clear all
await StorageService().clear();
```

### Connectivity Service
```dart
// Check connection
bool connected = await ConnectivityService().hasConnection;

// Listen for changes
ConnectivityService().onConnectivityChanged.listen((result) {
  if (result.contains(ConnectivityResult.none)) {
    print('No internet!');
  }
});
```

---

## ?? Example: Adding New Feature

### Step 1: Create Model
```dart
// lib/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(...);
}
```

### Step 2: Create Controller
```dart
// lib/controllers/user_controller.dart
class UserController extends GetxController {
  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final response = await ApiService().get('/users');
      users.value = (response['data'] as List)
        .map((u) => UserModel.fromJson(u))
        .toList();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Step 3: Create View
```dart
// lib/views/user_page.dart
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadUsers,
          );
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(controller.users[i].name),
          ),
        );
      }),
    );
  }
}
```

### Step 4: Add Route
```dart
// lib/routes/app_routes.dart
static const String users = '/users';

// lib/routes/app_pages.dart
GetPage(name: AppRoutes.users, page: () => const UserPage())
```

### Step 5: Navigate
```dart
Get.toNamed(AppRoutes.users);
```

---

## ? Quality Checklist

- ? No lint issues (`flutter analyze` = 0 issues)
- ? Proper null safety throughout
- ? All imports use correct paths (no broken references)
- ? Controllers properly initialized with `Get.put()`
- ? Error states handled (loading, error, empty)
- ? No hardcoded strings (use localization)
- ? No debug prints in production code
- ? Proper use of constants for API endpoints

---

## ?? Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** — Deep dive into MVC pattern & examples
- **[SETUP.md](SETUP.md)** — Installation, environment config, troubleshooting
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — Coding guidelines, naming conventions, patterns
- **[AUDIT_REPORT.md](AUDIT_REPORT.md)** — Production readiness verification

---

## ??? Available Scripts

```bash
# Analysis and testing
flutter analyze --no-pub              # Check code quality
flutter test                          # Run unit tests
flutter test --coverage               # Generate coverage report

# Building
flutter build apk                     # Build Android APK
flutter build ios                     # Build iOS app
flutter build web                     # Build web version
flutter build windows                 # Build Windows app

# Development
flutter run                           # Run on connected device
flutter run -d chrome                 # Run on web browser
flutter run --debug                   # Debug mode
flutter run --profile                 # Profile mode
flutter run --release                 # Release mode

# Cleaning
flutter clean                         # Clean build artifacts
flutter pub get                       # Get dependencies
flutter pub upgrade                   # Upgrade packages
```

---

## ?? Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **get** | 4.7.2+ | State management, routing, DI |
| **http** | 1.3.0+ | HTTP client for API calls |
| **shared_preferences** | 2.3.0+ | Local data persistence |
| **connectivity_plus** | 5.0.0+ | Network connectivity detection |
| **flutter_lints** | latest | Code quality analysis |

---

## ?? Security Best Practices

1. **Never commit tokens** — Use environment files (.env)
2. **Validate inputs** — Always validate user input
3. **Use HTTPS** — Always use encrypted connections
4. **Secure storage** — Use platform-specific secure storage for sensitive data
5. **Token refresh** — Implement automatic token refresh on 401
6. **Error messages** — Don't expose internal errors to users

---

## ?? Deployment

### Android
```bash
flutter build apk --release
# APK stored in: build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios --release
# Use Xcode: open ios/Runner.xcworkspace
```

### Web
```bash
flutter build web --release
# Hosted files in: build/web/
```

---

## ?? Contributing

1. Follow naming conventions in CONTRIBUTING.md
2. Run `flutter analyze` before committing
3. Keep controllers, services, and views focused
4. Write self-documenting code
5. Add comments for complex logic
6. Test new features before merging

---

## ?? Support & Issues

- Check [SETUP.md](SETUP.md) for common issues
- Review [ARCHITECTURE.md](ARCHITECTURE.md) for pattern questions
- Check existing documentation before creating issues
- Include `flutter doctor -v` output when reporting bugs

---

## ?? License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ?? For Teams

This project is designed for:
- **300+ parallel projects** with consistent architecture
- **300+ developers** with clear patterns and guidelines
- **30-60 day sprints** with rapid feature delivery
- **Maintenance-free scaling** with minimal technical debt

---

<div align="center">

**Made with ?? for scalable Flutter development**

? Star us on GitHub if this helps you! ?

</div>
