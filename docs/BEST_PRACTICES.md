# ✨ BEST PRACTICES - Coding Standards

Follow these standards for clean, maintainable code.

---

## **1. Naming Conventions**

### **Files**
```dart
✅ GOOD:
login_controller.dart
product_model.dart
products_page.dart
custom_button.dart

❌ BAD:
login.dart
product.dart
page.dart
button.dart
```

### **Classes**
```dart
✅ GOOD:
class LoginController extends BaseController { }
class ProductModel { }
class LoginPage extends StatelessWidget { }
class CustomButton extends StatelessWidget { }

❌ BAD:
class LoginCtrl { }
class Product { }
class LoginPg { }
class Button { }
```

### **Variables**
```dart
✅ GOOD:
final isLoading = false.obs;
final productsList = <ProductModel>[].obs;
final errorMessage = ''.obs;
final selectedUser = Rxn<User>();

❌ BAD:
final loading = false.obs;
final products = <ProductModel>[].obs;
final error = ''.obs;
final user = Rxn<User>();  // Too vague
```

### **Methods**
```dart
✅ GOOD:
Future<void> loadProducts() { }
String validateEmail(String email) { }
void togglePasswordVisibility() { }
Future<void> submitForm() { }

❌ BAD:
Future<void> load() { }
String validate(String v) { }
void toggle() { }
Future<void> submit() { }
```

---

## **2. File Organization**

### **One responsibility per file**

```dart
✅ GOOD:
lib/models/
├── product_model.dart     (ProductModel only)
├── login_response.dart    (LoginResponse only)
└── user_model.dart        (UserModel only)

❌ BAD:
lib/models/
├── models.dart            (All models in one file)
└── responses.dart         (All responses together)
```

### **Related files grouped by feature**

```dart
✅ GOOD:
lib/
├── controllers/products_controller.dart
├── models/product_model.dart
├── views/screens/products/products_page.dart
└── views/base/product_card.dart

❌ BAD:
lib/
├── products_controller.dart
├── product_model.dart
├── products_page.dart
└── product_card.dart  (scattered)
```

---

## **3. State Management**

### **Use .obs for reactive changes**

```dart
✅ GOOD:
final count = 0.obs;
count.value = 10;  // UI auto-updates

Obx(() => Text('Count: ${count.value}'))

❌ BAD:
int count = 0;     // Not reactive
count = 10;        // UI doesn't rebuild

Text('Count: $count')  // Won't update
```

### **Wrap in Obx() for reactive UI**

```dart
✅ GOOD:
Obx(() {
  if (isLoading.value) return LoadingWidget();
  return DataWidget();
})

❌ BAD:
if (isLoading.value) return LoadingWidget();
return DataWidget();  // Doesn't rebuild
```

---

## **4. Error Handling**

### **Always handle errors**

```dart
✅ GOOD:
final result = await apiCall<Data>(
  () => _api.get('/data'),
  handleError: true,  // Show error to user
);

if (result == null) return;  // Error occurred
process(result);

❌ BAD:
final result = await apiCall<Data>(
  () => _api.get('/data'),
  handleError: false,  // Ignore errors!
);

process(result);  // Might crash if null
```

### **Handle all error states in UI**

```dart
✅ GOOD:
Obx(() {
  if (isLoading.value) return LoadingWidget();
  if (hasError.value) return AppErrorWidget(...);
  if (items.isEmpty) return EmptyWidget();
  return ListView(...);
})

❌ BAD:
Obx(() => ListView(...))  // No error handling!
```

---

## **5. Resource Cleanup**

### **Dispose resources in onClose()**

```dart
✅ GOOD:
class MyController extends BaseController {
  late TextEditingController emailCtrl;
  late StreamSubscription _subscription;
  
  @override
  void onInit() {
    emailCtrl = TextEditingController();
    _subscription = stream.listen(...);
  }
  
  @override
  void onClose() {
    emailCtrl.dispose();
    _subscription.cancel();
    super.onClose();
  }
}

❌ BAD:
class MyController extends BaseController {
  late TextEditingController emailCtrl;
  
  @override
  void onInit() {
    emailCtrl = TextEditingController();
  }
  // onClose not implemented - MEMORY LEAK!
}
```

---

## **6. Input Validation**

### **Always validate user input**

```dart
✅ GOOD:
String? validateEmail(String? value) {
  if (value?.isEmpty ?? true) return 'Email required';
  if (!value!.contains('@')) return 'Invalid email';
  return null;
}

CustomTextField(
  validator: (val) => validateEmail(val),
)

❌ BAD:
CustomTextField()  // No validation!
```

---

## **7. API Endpoints**

### **Centralize all endpoints**

```dart
✅ GOOD:
// lib/services/api_endpoints.dart
class ApiEndpoints {
  static const String products = '/products/';
  static String productById(int id) => '/products/$id/';
}

// In controller
final data = await _api.get(ApiEndpoints.products);

❌ BAD:
// Scattered throughout code
final data = await _api.get('/products/');
final item = await _api.get('https://api.../products/1');
```

---

## **8. Comments & Documentation**

### **Comment complex logic only**

```dart
✅ GOOD:
/// Authenticates user and saves token to secure storage.
/// Throws [ApiException] if credentials are invalid.
Future<void> login(String email, String password) async {
  // Validate email format before API call
  if (!email.contains('@')) throw ArgumentError('Invalid email');
  
  final response = await _api.post(...);
  // Some complex logic here
}

❌ BAD:
// Login method
void login() {
  // Get email
  var email = emailCtrl.text;
  // Get password
  var password = passwordCtrl.text;
  // ...
}
```

---

## **9. Function Size**

### **Keep functions small (max 50 lines)**

```dart
✅ GOOD:
Future<void> login() async {
  if (!validate()) return;
  sendLoginRequest();  // Call helper
}

Future<void> sendLoginRequest() async {
  // 10-15 lines
}

❌ BAD:
Future<void> login() async {
  // 100+ lines of code
  // Hard to read and test
}
```

---

## **10. Imports Ordering**

### **Organize imports properly**

```dart
✅ GOOD:
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// 4. Local imports
import 'package:flutter_classic_mvc/services/api_service.dart';
import 'package:flutter_classic_mvc/models/product_model.dart';

❌ BAD:
import 'package:http/http.dart';
import 'package:flutter_classic_mvc/models/product_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';  // Random order!
```

---

## **11. Code Review Checklist**

Before pushing code:

```dart
// Runs with 0 issues
flutter analyze --no-pub

// Code is properly formatted
dart format .

// No unused imports/variables
flutter analyze | grep "unused"

// Tests pass
flutter test

// No print() statements
grep -r "print(" lib/  // Should be empty

// Error states handled
// Must have: Loading, Error, Empty states

// Resources disposed
// Check: TextEditingController.dispose(), Stream.cancel()

// Comments on complex code
// Review: Logic explanations

// Function size < 50 lines
// Check: Long methods broken down
```

---

## **12. Performance Tips**

### **Avoid unnecessary rebuilds**

```dart
✅ GOOD:
// Only rebuild when items change
Obx(() => ListView(children: items))

❌ BAD:
// Rebuilds entire page when anything changes
Obx(() => Scaffold(...))
```

### **Use const widgets**

```dart
✅ GOOD:
const SizedBox(height: 16)
const Icon(Icons.search)

❌ BAD:
SizedBox(height: 16)
Icon(Icons.search)
```

### **Lazy load controllers**

```dart
✅ GOOD:
GetPage(
  name: AppRoutes.products,
  page: () {
    Get.put(ProductsController());  // Created on route access
    return ProductsPage();
  },
)

❌ BAD:
final controller = ProductsController();  // Created immediately
```

---

## **13. Testing**

### **Test important logic**

```dart
✅ GOOD:
void main() {
  test('validateEmail returns error for invalid email', () {
    expect(validateEmail('invalid'), 'Invalid email');
  });
  
  test('controller loads items on init', () async {
    final controller = MyController();
    await controller.onInit();
    expect(controller.items.isNotEmpty, true);
  });
}

❌ BAD:
// No tests
```

---

## **14. Security**

### **Never hardcode sensitive data**

```dart
✅ GOOD:
// Use environment variables
String apiKey = EnvironmentConfig.apiKey;

// Or secure storage
final token = await StorageService().getToken();

❌ BAD:
const String API_KEY = 'abcd1234';  // Exposed!
```

---

## ✅ Standards Checklist

- [ ] Files have single responsibility
- [ ] Classes follow naming convention
- [ ] All .obs watched with Obx()
- [ ] All error states handled
- [ ] Resources disposed in onClose()
- [ ] Input validated before use
- [ ] Endpoints centralized
- [ ] Comments on complex logic
- [ ] Functions under 50 lines
- [ ] Imports organized
- [ ] No print() statements
- [ ] Tests written
- [ ] No hardcoded secrets

---

## 📚 Next Steps

- 👉 [**TROUBLESHOOTING.md**](TROUBLESHOOTING.md) - Common issues
- 👉 [**TESTING.md**](TESTING.md) - Write tests
- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - See examples

---

**Follow these standards = Clean, maintainable code!**
