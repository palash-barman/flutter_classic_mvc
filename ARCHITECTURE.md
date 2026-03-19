# 📚 API DOCUMENTATION & ARCHITECTURE GUIDE

Complete guide to understanding and using the Classic MVC architecture for **300+ Developers**.

---

## 🏗️ Architecture Overview

```
Request Flow:
┌─────────────┐
│   UI View   │  (login_page.dart - StatelessWidget)
└──────┬──────┘
       │ User Action (Button press, Form submit)
       ↓
┌─────────────────────────────────┐
│ Controller (GetxController)     │  (login_controller.dart)
│ - Business Logic                │  - apiCall() wrapper
│ - State Management (.obs)       │  - Error handling
│ - API Orchestration             │
└──────┬──────────────────────────┘
       │ Calls API Service
       ↓
┌──────────────────────────────────┐
│ Services                         │
│ - ApiService (HTTP)              │  (api_service.dart)
│ - StorageService                 │  (storage_service.dart)
│ - ConnectivityService            │  (connectivity_service.dart)
└──────┬───────────────────────────┘
       │
       ↓
┌──────────────────────────────────┐
│ Models (Data Classes)            │
│ - LoginResponse                  │  (login_response.dart)
│ - ProductModel                   │  (product_model.dart)
└──────┬───────────────────────────┘
       │ Backend API
       ↓
  [External API]
```

---

## 📱 Controllers

### **BaseController** (Not active, but reference pattern)
```dart
// Located in: lib/core/base/base_controller.dart
// Provides: apiCall<T>() utility method for error/loading handling

// Pattern (Old):
final result = await apiCall<LoginResponse>(
  () async { /* API call */ },
  showLoading: true,
  handleError: true,
);
```

### **Current Controller Pattern**
```dart
// lib/controllers/login_controller.dart
class LoginController extends GetxController {
  // Reactive state
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  // Dependencies
  final _api = ApiService();
  
  // Methods
  Future<void> login() async {
    try {
      isLoading.value = true;
      final response = await _api.post(
        ApiEndpoints.login,
        body: {'email': email, 'password': password},
      );
      // Handle response
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

### **State Management Pattern**
```
Controller Updates State → View Listens (Obx) → UI Rebuilds

Example:
final isLoading = false.obs;  // Observable boolean

// In UI:
Obx(() => isLoading.value ? LoadingWidget() : DataWidget())

// In Controller:
isLoading.value = true;  // Update → UI auto-rebuilds
```

---

## 🎨 Views (Pages)

### **View Structure**
```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Initialize controller
    final controller = Get.put(LoginController());
    
    // Step 2: Build UI with reactive state
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingWidget();
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.login,
          );
        }
        
        return Form(/* Input fields */);
      }),
    );
  }
}
```

### **UI State Pattern**
```
┌─────────────────────────────┐
│ IsLoading                   │
├─────────────────────────────┤
│ true  → Show LoadingWidget  │
│ false → Continue            │
└─────────────────────────────┘
         ↓
┌─────────────────────────────┐
│ HasError                    │
├─────────────────────────────┤
│ true  → Show ErrorWidget    │
│ false → Continue            │
└─────────────────────────────┘
         ↓
┌─────────────────────────────┐
│ IsEmpty                     │
├─────────────────────────────┤
│ true  → Show EmptyWidget    │
│ false → Show Data           │
└─────────────────────────────┘
```

---

## 📦 Models

### **Model Pattern**
```dart
class ProductModel {
  final int id;
  final String name;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
  });

  // JSON Serialization
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };
}
```

### **Request/Response DTOs**
```dart
// Request DTO
class LoginRequest {
  final String email;
  final String password;
  
  LoginRequest({required this.email, required this.password});
  
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

// Response DTO
class LoginResponse {
  final Data? data;
  final String? message;
  
  LoginResponse({this.data, this.message});
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}
```

---

## 🔌 Services

### **API Service**
```dart
// Location: lib/services/api_service.dart

// Usage:
final apiService = ApiService();

// GET Request
final response = await apiService.get(
  '/products',
  queryParams: {'page': 1},
);

// POST Request
final response = await apiService.post(
  '/login',
  body: {'email': 'user@example.com', 'password': 'pass'},
);

// PUT Request
final response = await apiService.put(
  '/products/1',
  body: {'name': 'New Name'},
);

// DELETE Request
await apiService.delete('/products/1');
```

### **Storage Service**
```dart
// Location: lib/services/storage_service.dart

// Initialize (call in main.dart)
await StorageService.init();

// Save token
await StorageService().saveToken('access_token_here');

// Get token
String? token = StorageService().getToken();

// Save theme preference
await StorageService().saveThemeMode(true);

// Save language
await StorageService().saveLanguageCode('en');

// Clear all data
await StorageService().clear();
```

### **Connectivity Service**
```dart
// Location: lib/services/connectivity_service.dart

// Check connection
bool hasInternet = await ConnectivityService().hasConnection;

// Listen for changes
ConnectivityService().onConnectivityChanged.listen((result) {
  if (result.contains(ConnectivityResult.none)) {
    print('No internet');
  }
});
```

---

## 🛣️ Routing & Navigation

### **Routes Definition**
```dart
// lib/routes/app_routes.dart
class AppRoutes {
  static const String login = '/login';
  static const String products = '/products';
}
```

### **Pages Configuration**
```dart
// lib/routes/app_pages.dart
static final pages = <GetPage>[
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: AppRoutes.products,
    page: () {
      Get.put(ProductsController());
      return const ProductsPage();
    },
    middlewares: [AuthMiddleware()],
  ),
];
```

### **Navigation Usage**
```dart
// Navigate to page
Get.toNamed(AppRoutes.products);

// Navigate with replacement (remove previous from stack)
Get.offNamed(AppRoutes.login);

// Navigate and clear all previous routes
Get.offAllNamed(AppRoutes.products);

// Navigate with arguments
Get.toNamed(AppRoutes.products, arguments: productId);

// Get arguments in page
final productId = Get.arguments as int;
```

---

## 🛡️ Error Handling

### **Exception Hierarchy**
```
Exception (base)
├── ApiException
│   ├── statusCode
│   ├── message
│   └── data
├── ConnectivityException
├── TimeoutException
└── StorageException
```

### **Error Handling in Controller**
```dart
Future<void> loadData() async {
  try {
    isLoading.value = true;
    errorMessage.value = '';
    
    final data = await apiService.get(endpoint);
    // Process data
    
  } on ApiException catch (e) {
    if (e.statusCode == 401) {
      // Handle unauthorized - logout
      Get.offAllNamed(AppRoutes.login);
    }
    errorMessage.value = e.message;
  } catch (e) {
    errorMessage.value = 'Unexpected error occurred';
  } finally {
    isLoading.value = false;
  }
}
```

### **Error Widgets**
```dart
// Loading state
if (controller.isLoading.value && controller.data.isEmpty) {
  return const LoadingWidget();
}

// Error state
if (controller.hasError.value && controller.data.isEmpty) {
  return AppErrorWidget(
    message: controller.errorMessage.value,
    onRetry: controller.refresh,
  );
}

// Empty state
if (controller.data.isEmpty) {
  return EmptyWidget(message: 'No items found');
}

// Success state
return ListView.builder(
  itemCount: controller.data.length,
  itemBuilder: (context, index) => ItemWidget(controller.data[index]),
);
```

---

## 📝 Common Patterns

### **Pagination Pattern**
```dart
class ProductsController extends GetxController {
  final products = <ProductModel>[].obs;
  int _currentPage = 1;
  final hasMore = true.obs;

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    
    try {
      final newProducts = await apiService.get(
        ApiEndpoints.products,
        queryParams: {'page': _currentPage},
      );
      
      products.addAll(newProducts);
      _currentPage++;
      hasMore.value = newProducts.length == pageSize;
    } catch (e) {
      // Handle error
    }
  }
}
```

### **Search Pattern**
```dart
Future<void> search(String query) async {
  try {
    isLoading.value = true;
    final results = await apiService.get(
      ApiEndpoints.products,
      queryParams: {'search': query},
    );
    products.value = results;
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}
```

### **Filter Pattern**
```dart
Future<void> applyFilter(String category) async {
  try {
    isLoading.value = true;
    final filtered = await apiService.get(
      ApiEndpoints.products,
      queryParams: {'category': category},
    );
    products.value = filtered;
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}
```

---

## 🔄 Complete Feature Example

### **User List Feature**

**1. Model**
```dart
// lib/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(...);
}
```

**2. Controller**
```dart
// lib/controllers/user_controller.dart
class UserController extends GetxController {
  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final _api = ApiService();

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final response = await _api.get(ApiEndpoints.users);
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

**3. View**
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
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadUsers,
          );
        }
        if (controller.users.isEmpty) {
          return EmptyWidget();
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
            );
          },
        );
      }),
    );
  }
}
```

**4. Add Route**
```dart
// lib/routes/app_routes.dart
static const String users = '/users';

// lib/routes/app_pages.dart
GetPage(name: AppRoutes.users, page: () => const UserPage())
```

**5. Navigate**
```dart
Get.toNamed(AppRoutes.users);
```

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Controllers | 2-10 (scales with features) |
| Models | 3-50 (per feature set) |
| Views | 2-50 (per feature set) |
| Services | 5 (constant) |
| Widgets | 5+ (reusable) |
| Routes | 3+ (main routes) |

---

## ✅ Best Practices

1. **Always check for null** - Use null-safety
2. **Use Obx wisely** - Only wrap reactive widgets
3. **Handle all error states** - Loading, Error, Empty, Success
4. **Validate inputs** - Never trust user input
5. **Use const constructors** - Optimize performance
6. **Keep methods small** - Max 30-50 lines
7. **Don't make API calls in build()** - Use controllers
8. **Use theme colors** - Don't hardcode colors
9. **Add comments** - Especially for complex logic
10. **Test edge cases** - Null, empty, error scenarios

---

**Architecture Guide Complete! 🎉**
For more help, check CONTRIBUTING.md and SETUP.md.
