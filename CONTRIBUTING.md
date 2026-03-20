# 📖 CONTRIBUTING GUIDELINES

Welcome to the **Classic MVC Demo Project** development team! This document provides guidelines for contributing code to ensure consistency and quality across all 300+ projects.

---

## 🎯 Development Standards

### **Code Style**
- Follow [Dart Code Style Guide](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze --fatal-infos` before committing
- Format code with `dart format .`
- Maximum line length: 80 characters (120 for URLs)

### **Naming Conventions**
```dart
// Files
feature_controller.dart
feature_model.dart
feature_page.dart
feature_widget.dart

// Classes
class FeatureController extends GetxController { }
class FeatureModel { }
class FeaturePage extends StatelessWidget { }
class FeatureWidget extends StatelessWidget { }

// Variables
final featureService = FeatureService();
final isLoading = false.obs;
final errorMessage = ''.obs;

// Methods
void loadFeatures() { }
Future<List<Feature>> getFeatures() async { }
String validateEmail(String email) { }
```

### **Imports Ordering**
```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// 4. Local project imports
import 'package:flutter_classic_mvc/services/api_service.dart';
import 'package:flutter_classic_mvc/models/feature_model.dart';
import 'package:flutter_classic_mvc/routes/app_routes.dart';
```

---

## 📂 Folder Structure for New Features

```
lib/
├── controllers/
│   └── new_feature_controller.dart    ← Controller logic
├── models/
│   ├── new_feature_model.dart         ← Main entity
│   ├── new_feature_request.dart       ← Request DTO (if needed)
│   └── new_feature_response.dart      ← Response DTO (if needed)
├── views/
│   └── new_feature_page.dart          ← UI screen
└── widgets/
    └── new_feature_widget.dart        ← Reusable components
```

---

## ✅ Development Checklist

### **Before Writing Code**
- [ ] Create feature branch: `git checkout -b feature/feature-name`
- [ ] Check if model already exists (avoid duplication)
- [ ] Plan API endpoints needed
- [ ] Identify reusable widgets

### **While Writing Code**
- [ ] Add proper null safety checks
- [ ] Handle all error scenarios
- [ ] Add loading states with `LoadingWidget`
- [ ] Add empty states with `EmptyWidget`
- [ ] Add error states with `AppErrorWidget`
- [ ] Use `GetX` for state management (`Obx()`, `.obs`)
- [ ] Validate all user inputs
- [ ] Keep methods small (max 50 lines)
- [ ] Add comments for complex logic

### **Code Review Checklist**
- [ ] Runs `flutter analyze` with 0 issues
- [ ] No unused imports or variables
- [ ] Follows naming conventions
- [ ] No hardcoded strings (use localization)
- [ ] No hardcoded URLs (use ApiEndpoints)
- [ ] Error handling implemented
- [ ] UI is responsive
- [ ] No performance bottlenecks

### **Before Committing**
- [ ] Run `flutter analyze --fatal-infos`
- [ ] Run `dart format .`
- [ ] Test on both Android and iOS
- [ ] Test with slow internet
- [ ] Test with no internet
- [ ] Write meaningful commit message

---

## 🔄 Git Workflow

### **Branch Naming**
```
feature/user-authentication
feature/product-listing
bugfix/login-page-crash
docs/api-documentation
```

### **Commit Messages**
```
✨ feat: add user authentication flow
🐛 fix: handle null response in API
📚 docs: update setup instructions
♻️ refactor: simplify error handling
⚡ perf: optimize image loading
🧪 test: add login controller tests
```

### **Pull Request Process**
1. Create feature branch
2. Make changes
3. Commit with meaningful messages
4. Push to remote
5. Create Pull Request
6. Request code review
7. Address feedback
8. Merge when approved

---

## 🛡️ Security Guidelines

### **API Communication**
- Always use HTTPS endpoints
- Never hardcode API keys (use environment variables)
- Use Bearer token authentication
- Validate all API responses
- Handle 401 Unauthorized (trigger re-login)

### **Data Storage**
- Use `SharedPreferences` only for non-sensitive data
- Never store passwords in local storage
- Use platform-specific secure storage for sensitive data
- Clear sensitive data on logout

### **Input Validation**
```dart
// Always validate user input
String? validateEmail(String? value) {
  if (value?.isEmpty ?? true) return 'Email required';
  if (!value!.contains('@')) return 'Invalid email';
  return null;
}
```

---

## 🧪 Testing Requirements

### **Unit Tests**
```dart
test('LoginController.login() returns token on success', () async {
  // Arrange
  // Act
  // Assert
});
```

### **Widget Tests**
```dart
testWidgets('LoginPage shows email input field', (WidgetTester tester) async {
  await tester.pumpWidget(const LoginPage());
  expect(find.byType(TextField), findsWidgets);
});
```

### **Integration Tests**
- Test complete user flows
- Test API integration
- Test error scenarios
- Test navigation

---

## 📝 Documentation Requirements

### **Code Comments**
```dart
/// Authenticates user with email and password.
/// 
/// Returns [LoginResponse] containing access token on success.
/// Throws [NetworkException] if no internet connection.
/// Throws [ValidationException] if email format is invalid.
Future<LoginResponse> login(String email, String password) async {
  // Implementation
}
```

### **README Updates**
- Document new APIs
- Document new features
- Document configuration options
- Include setup instructions

---

## 🚀 Performance Guidelines

### **Do's**
- ✅ Use `const` constructors
- ✅ Use `Obx()` only for reactive widgets
- ✅ Implement pagination for large lists
- ✅ Use `cached_network_image` for images
- ✅ Lazy load data when possible

### **Don'ts**
- ❌ Don't rebuild entire widget tree
- ❌ Don't make API calls in build()
- ❌ Don't hardcode colors (use theme)
- ❌ Don't load all data at once
- ❌ Don't use synchronous operations in UI thread

---

## 🎓 Example: Adding New Feature

### **1. Create Model**
```dart
// lib/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
```

### **2. Create Controller**
```dart
// lib/controllers/user_controller.dart
class UserController extends GetxController {
  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      // Load users from API
      users.value = await ApiService().get('/users');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

### **3. Create View**
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
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }
        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(message: controller.errorMessage.value);
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(controller.users[index].name),
            );
          },
        );
      }),
    );
  }
}
```

### **4. Add Route**
```dart
// lib/routes/app_routes.dart
static const String users = '/users';

// lib/routes/app_pages.dart
GetPage(
  name: AppRoutes.users,
  page: () => UserPage(),
)
```

---

## ❓ FAQ

**Q: How do I add a new API endpoint?**
A: Add it to `lib/services/api_endpoints.dart` and use it in your controller.

**Q: How do I reuse a widget across multiple pages?**
A: Create it in `lib/widgets/` and import it wherever needed.

**Q: How do I handle API errors?**
A: Use try-catch, update error state, and show `AppErrorWidget`.

**Q: Can I create custom widgets?**
A: Yes, create them in `lib/widgets/` following the naming convention.

---

## 📞 Support & Questions

For questions or clarifications, contact the core team or check the AUDIT_REPORT.md.

**Happy Coding! 🚀**
