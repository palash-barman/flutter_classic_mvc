# 💡 CORE CONCEPTS - GetX, BaseController & Dependency Injection

Essential concepts you need to understand.

---

## 🎯 What is GetX?

GetX is a Flutter state management solution that makes managing app state simple.

**Three main features:**
1. **State Management** - `.obs` variables that auto-notify UI
2. **Navigation** - Easy routing with `Get.toNamed()`
3. **Dependency Injection** - Easy service registration with `Get.put()`

---

## 🔄 Observable Variables (.obs)

Variables that automatically notify UI when they change.

### **Creating Observable Variables**

```dart
// Boolean
final isLoading = false.obs;

// String
final errorMessage = ''.obs;

// List
final productsList = <ProductModel>[].obs;

// Nullable
final selectedItem = Rxn<ProductModel>();
```

### **Reading Observable Values**

```dart
// Reading
print(isLoading.value);          // false
print(productsList.value.length); // 0

// Checking if null
if (selectedItem.value != null) {
  print(selectedItem.value!.name);
}
```

### **Updating Observable Values**

```dart
// Assignment
isLoading.value = true;

// List operations
productsList.add(newProduct);
productsList.removeAt(0);
productsList.clear();

// Toggle
isLoading.toggle();
```

---

## 📺 Obx - Reactive UI

Wraps a widget to auto-rebuild when observed variables change.

```dart
// UI automatically rebuilds when isLoading.value changes
Obx(() {
  if (isLoading.value) {
    return LoadingWidget();
  }
  return DataWidget();
})
```

### **Why Obx?**

❌ **Without Obx** - Manual rebuild
```dart
// Doesn't rebuild when isLoading changes
if (controller.isLoading.value) {
  return LoadingWidget();
}
return DataWidget();
```

✅ **With Obx** - Automatic rebuild
```dart
// Rebuilds ONLY when isLoading changes
Obx(() {
  if (controller.isLoading.value) {
    return LoadingWidget();
  }
  return DataWidget();
})
```

### **Obx vs GetBuilder**

| Feature | Obx | GetBuilder |
|---------|-----|-----------|
| Reactive | Yes (.obs) | Manual |
| Syntax | Function | Builder |
| Performance | Better | Lighter |
| Usage | Most cases | Simple cases |

```dart
// Obx - Automatic
Obx(() => Text(controller.title.value))

// GetBuilder - Manual update
GetBuilder<MyController>(
  builder: (controller) => Text(controller.title),
)
```

---

## 🎮 GetxController

Base class for all controllers (state management).

```dart
class MyController extends GetxController {
  // 1. State variables
  final count = 0.obs;
  final items = <String>[].obs;
  
  // 2. Methods
  void increment() => count.value++;
  void addItem(String item) => items.add(item);
  
  // 3. Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    // Called when controller created
    print('Controller initialized');
  }
  
  @override
  void onReady() {
    super.onReady();
    // Called when first frame rendered
  }
  
  @override
  void onClose() {
    super.onClose();
    // Called when controller destroyed
    // Clean up resources here
  }
}
```

### **Lifecycle Flow**

```
1. Controller created
   ↓ (onInit)
2. First frame rendered
   ↓ (onReady)
3. Page active
   ↓
4. Page closed
   ↓ (onClose)
5. Controller destroyed
```

---

## 🏗️ BaseController - Special Helper

Extends GetxController with extra helper method for API calls.

```dart
// Located in: lib/core/base/base_controller.dart
abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;
  
  // Special method for API calls with auto error/loading
  Future<T?> apiCall<T>(
    Future<T> Function() call, {
    bool showLoading = true,
    bool handleError = true,
  }) async {
    // Auto handles: loading, errors, state updates
  }
}
```

### **Why BaseController?**

**Without BaseController:**
```dart
Future<void> login() async {
  isLoading.value = true;
  try {
    final response = await _api.post(...);
    final data = LoginResponse.fromJson(response);
    return data;
  } catch (e) {
    errorMessage.value = e.toString();
    showSnackbar(errorMessage.value);
  } finally {
    isLoading.value = false;
  }
}
```

**With BaseController:**
```dart
Future<void> login() async {
  final result = await apiCall<LoginResponse>(
    () async {
      final data = await _api.post(...);
      return LoginResponse.fromJson(data);
    },
    showLoading: true,
    handleError: true,
  );
  
  if (result != null) {
    // Success
  }
}
```

### **Using apiCall**

```dart
class MyController extends BaseController {
  Future<void> loadData() async {
    // One simple line for API call!
    final result = await apiCall<MyData>(
      () async {
        final response = await _api.get('/data');
        return MyData.fromJson(response);
      },
      showLoading: true,      // Show spinner
      handleError: true,      // Auto show error
    );
    
    if (result != null) {
      // Use data
      process(result);
    }
    // Error already shown to user
  }
}
```

---

## 🔌 Dependency Injection (Get.put)

Register services/controllers so they can be used anywhere.

### **Three Ways to Register**

#### **1. Global Bindings (Permanent)**

```dart
// lib/core/global/global_bindings.dart
class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // These are available everywhere, never removed
    Get.put(LoadingController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(LocalizationController(), permanent: true);
  }
}

// In main.dart
runApp(
  GetMaterialApp(
    initialBinding: GlobalBindings(),  // Register globally
    home: MyApp(),
  ),
);
```

#### **2. Route Registration (Lazy Loading)**

```dart
// lib/routes/app_pages.dart
GetPage(
  name: AppRoutes.products,
  page: () {
    Get.put(ProductsController());  // Created when route accessed
    return ProductsPage();
  },
)
```

#### **3. In Page (On Demand)**

```dart
// lib/views/screens/my_page.dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyController());  // Created here
    
    return Scaffold(
      body: Obx(() => Text(controller.title.value)),
    );
  }
}
```

### **Using Registered Services**

```dart
// Get existing controller
final controller = Get.find<MyController>();

// Shorthand in pages
final controller = Get.find<ProductsController>();

// Check if registered
if (Get.isRegistered<MyController>()) {
  // ...
}

// Delete controller
Get.delete<MyController>();
```

---

## 🛣️ Navigation (GetX Routes)

Easy page routing without context.

### **Route Definition**

```dart
// lib/routes/app_routes.dart
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String products = '/products';
}

// lib/routes/app_pages.dart
class AppPages {
  static const initial = AppRoutes.splash;
  
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.products,
      page: () {
        Get.put(ProductsController());
        return ProductsPage();
      },
      middlewares: [AuthMiddleware()],  // Route guard
    ),
  ];
}
```

### **Navigate**

```dart
// Push new route (go forward)
Get.toNamed(AppRoutes.products);

// Replace current route (go to page)
Get.offNamed(AppRoutes.products);

// Clear all routes and go to
Get.offAllNamed(AppRoutes.splash);

// Pop/go back
Get.back();

// Pass data back
Get.back(result: 'some data');
```

### **Route Guards (Middleware)**

```dart
// lib/routes/auth_middleware.dart
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if logged in
    final token = StorageService().getToken();
    
    if (token == null) {
      return RouteSettings(name: AppRoutes.login);
    }
    // Allow access
    return null;
  }
}
```

---

## 🎨 Error Handling

Global error handling with centralized snackbars.

```dart
// lib/core/error/error_handler.dart
class ErrorHandler {
  static void handle(dynamic error) {
    final message = _extractMessage(error);
    showSnackbar(message);
  }
  
  static void showSnackbar(String message, {bool isError = true}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    );
  }
}

// Usage
try {
  await _api.post(...);
} catch (e) {
  ErrorHandler.handle(e);
}
```

---

## 🔑 Reactive Forms Example

Complete example combining everything:

```dart
// Controller
class FormController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final isSubmitting = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final result = await apiCall<SubmitResponse>(
      () => _api.post('/submit', body: {
        'name': nameCtrl.text,
        'email': emailCtrl.text,
      }),
      showLoading: true,
    );

    if (result != null) {
      ErrorHandler.showSnackbar('Success', isError: false);
      Get.back(result: result);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}

// UI
class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FormController());

    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                controller: controller.nameCtrl,
                labelText: 'Name',
                checkEmpty: true,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: controller.emailCtrl,
                labelText: 'Email',
                isEmail: true,
              ),
              SizedBox(height: 24),
              Obx(() => CustomButton(
                onTap: controller.submit,
                text: 'Submit',
                loading: controller.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## ✅ Quick Checklist

- [ ] Understand `.obs` - Observable variables
- [ ] Know `Obx()` - Auto-rebuild wrapper
- [ ] Use `GetxController` - For state management
- [ ] Extend `BaseController` - For API calls
- [ ] Use `Get.put()` - Register services
- [ ] Use `Get.find<>()` - Access services
- [ ] Navigate with `Get.toNamed()` - Routing
- [ ] Handle errors globally - ErrorHandler

---

## 📚 Next Steps

- 👉 [**STATE_MANAGEMENT.md**](STATE_MANAGEMENT.md) - Create controllers
- 👉 [**API_GUIDE.md**](API_GUIDE.md) - Make API calls
- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - See examples

---

**Key Takeaway:** GetX makes state management simple. Just use `.obs` for variables and `Obx()` to listen!
