# 📁 PROJECT STRUCTURE - Folder Organization

Complete breakdown of what goes where.

---

## **Complete Folder Tree**

```
flutter_classic_mvc/
│
├── 📘 DOCUMENTATION
│   ├── README_DOCS.md           ← Documentation index (start here)
│   ├── QUICK_START.md           ← 5 minute setup
│   ├── SETUP.md                 ← Complete installation
│   ├── PROJECT_STRUCTURE.md     ← This file
│   ├── ARCHITECTURE.md          ← MVC architecture
│   ├── CORE_CONCEPTS.md         ← GetX, BaseController
│   ├── API_GUIDE.md             ← HTTP services
│   ├── WIDGETS_GUIDE.md         ← Custom widgets
│   ├── STATE_MANAGEMENT.md      ← Controllers & state
│   ├── ADD_FEATURES.md          ← How to add features
│   ├── CODE_EXAMPLES.md         ← Real-world examples
│   ├── PATTERNS.md              ← Common patterns
│   ├── BEST_PRACTICES.md        ← Coding standards
│   ├── TROUBLESHOOTING.md       ← Issues & fixes
│   ├── TESTING.md               ← Testing guide
│   └── BUILD_DEPLOYMENT.md      ← Release builds
│
├── 🎯 lib/                      ← Main app code (most important)
│   ├── main.dart                ← App entry point
│   │
│   ├── 📱 controllers/          ← Business logic & state
│   │   ├── login_controller.dart
│   │   ├── products_controller.dart
│   │   └── splash_controller.dart
│   │
│   ├── 📺 views/                ← UI Screens & Widgets
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   └── login_page.dart
│   │   │   ├── products/
│   │   │   │   └── products_page.dart
│   │   │   ├── profile/
│   │   │   │   └── profile_page.dart
│   │   │   └── splash/
│   │   │       └── splash_page.dart
│   │   │
│   │   └── base/                ← Reusable UI components
│   │       ├── custom_button.dart
│   │       ├── custom_text_field.dart
│   │       ├── custom_image.dart
│   │       ├── loading_widget.dart
│   │       ├── error_widget.dart
│   │       ├── empty_widget.dart
│   │       ├── product_card.dart
│   │       ├── profile_picture.dart
│   │       ├── custom_image_picker.dart
│   │       ├── app_list_view.dart
│   │       └── no_internet_widget.dart
│   │
│   ├── 📊 models/               ← Data classes
│   │   ├── product_model.dart
│   │   └── login_response.dart
│   │
│   ├── 🔧 services/             ← External services
│   │   ├── api_service.dart     ← HTTP client (GET, POST, etc)
│   │   ├── api_endpoints.dart   ← API routes
│   │   ├── api_exception.dart   ← Error handling
│   │   ├── storage_service.dart ← Local storage (SharedPrefs)
│   │   └── connectivity_service.dart ← Network status
│   │
│   ├── 🌐 routes/               ← Navigation
│   │   ├── app_pages.dart       ← Route definitions
│   │   ├── app_routes.dart      ← Route constants
│   │   └── auth_middleware.dart ← Route guards
│   │
│   └── 💎 core/                 ← Core utilities
│       ├── base/
│       │   └── base_controller.dart ← Abstract controller
│       ├── config/
│       │   ├── environment.dart
│       │   └── app_constants.dart
│       ├── constants/
│       ├── error/
│       │   └── error_handler.dart
│       ├── global/
│       │   ├── global_bindings.dart
│       │   ├── loading_controller.dart
│       │   └── loading_overlay.dart
│       ├── localization/
│       │   ├── app_translations.dart
│       │   └── localization_controller.dart
│       ├── theme/
│       │   ├── app_theme.dart
│       │   └── theme_controller.dart
│       └── utils/
│           ├── app_validator.dart
│           ├── formatter.dart
│           ├── logger.dart
│           └── responsive.dart
│
├── 📱 android/                  ← Android native code
│   ├── app/src/
│   ├── build.gradle.kts
│   └── gradle.properties
│
├── 🍎 ios/                      ← iOS native code
│   ├── Runner/
│   └── Runner.xcodeproj
│
├── 🌐 web/                      ← Web support (optional)
│   └── index.html
│
├── 📋 pubspec.yaml              ← Dependencies & metadata
├── 📋 analysis_options.yaml     ← Dart linter settings
└── 🔒 .gitignore                ← Git ignore rules
```

---

## 📂 Folder Purpose Summary

### **Core Folders You'll Use Most**

| Folder | Purpose | You Modify When |
|--------|---------|-----------------|
| `lib/controllers/` | Business logic, state | Adding features, API calls |
| `lib/views/screens/` | Full pages | Creating new screens |
| `lib/views/base/` | Reusable widgets | Creating UI components |
| `lib/models/` | Data structures | Adding API responses |
| `lib/services/` | External services | Integrating APIs |
| `lib/routes/` | Navigation | Adding new pages |
| `lib/core/utils/` | Helpers | Adding utility functions |

---

## 🎯 Where to Find Things

### **Need to display a product list?**
```
controllers/products_controller.dart  ← State management
models/product_model.dart             ← Data structure
views/screens/products/               ← UI screen
views/base/product_card.dart          ← Item widget
services/api_endpoints.dart           ← API route
```

### **Need to add login?**
```
controllers/login_controller.dart     ← Auth logic
models/login_response.dart            ← Response data
views/screens/auth/login_page.dart    ← Login form
views/base/custom_text_field.dart     ← Input fields
views/base/custom_button.dart         ← Submit button
```

### **Need to call API?**
```
services/api_service.dart             ← Make HTTP call
services/api_endpoints.dart           ← Define endpoint
core/error/error_handler.dart         ← Handle errors
models/[model_name].dart              ← Parse response
```

### **Need to show loading/error/empty?**
```
views/base/loading_widget.dart        ← Show spinner
views/base/error_widget.dart          ← Show error
views/base/empty_widget.dart          ← Show empty
```

---

## 🔄 Architecture Layers

```
USER INTERACTION
       ↓
┌─────────────────────┐
│  VIEW LAYER         │ lib/views/screens
│  LoginPage          │
└─────────────────────┘
       ↓
┌─────────────────────┐
│  CONTROLLER LAYER   │ lib/controllers
│  LoginController    │ (GetxController)
└─────────────────────┘
       ↓
┌─────────────────────┐
│  SERVICE LAYER      │ lib/services
│  ApiService         │
│  StorageService     │
└─────────────────────┘
       ↓
┌─────────────────────┐
│  MODEL LAYER        │ lib/models
│  LoginResponse      │
│  ProductModel       │
└─────────────────────┘
       ↓
   EXTERNAL API
```

---

## 📚 File Naming Conventions

| Type | Naming | Example |
|------|--------|---------|
| Controllers | `*_controller.dart` | `login_controller.dart` |
| Pages/Screens | `*_page.dart` | `login_page.dart` |
| Widgets | `*_widget.dart` or custom | `product_card.dart` |
| Models | `*_model.dart` | `product_model.dart` |
| Services | `*_service.dart` | `api_service.dart` |

---

## 🆚 Different Folder Types

### **📱 controllers/**
Where state management lives
```dart
// Business logic, API calls, .obs variables
class LoginController extends BaseController {
  final isLoading = false.obs;
  Future<void> login() { ... }
}
```

### **📺 views/screens/**
Full page screens
```dart
// Entire page that users see
class LoginPage extends StatelessWidget { }
```

### **views/base/**
Reusable UI components
```dart
// Small widgets used in multiple places
class CustomButton extends StatelessWidget { }
```

### **📊 models/**
Data structures
```dart
// Define data shape, JSON parsing
class ProductModel {
  final int id;
  final String name;
  factory ProductModel.fromJson(...) { }
}
```

### **🔧 services/**
External integrations
```dart
// API calls, storage, network
class ApiService {
  Future<dynamic> get(String endpoint) { }
}
```

### **💎 core/utils/**
Common utilities
```dart
// Helpers used everywhere
String validateEmail(String email) { }
```

---

## ✅ Quick Reference

**Adding a new feature?** Follow this structure:

```
1. Create model       → lib/models/feature_model.dart
2. Add endpoint       → lib/services/api_endpoints.dart
3. Create controller  → lib/controllers/feature_controller.dart
4. Create page        → lib/views/screens/feature/feature_page.dart
5. Create widget      → lib/views/base/feature_card.dart (if needed)
6. Add route          → lib/routes/app_pages.dart
   Add route constant → lib/routes/app_routes.dart
```

---

## 📚 Next Steps

- 👉 [**ARCHITECTURE.md**](ARCHITECTURE.md) - Understand MVC flow
- 👉 [**CORE_CONCEPTS.md**](CORE_CONCEPTS.md) - Learn GetX
- 👉 [**ADD_FEATURES.md**](ADD_FEATURES.md) - Create your first feature

---

**Bookmark:** This file for quick reference!
