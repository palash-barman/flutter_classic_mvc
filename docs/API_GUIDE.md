# 🔌 API GUIDE - HTTP Services & Endpoints

How to make API calls, handle errors, and manage endpoints.

---

## 📡 ApiService - HTTP Client

Main service for all API communication.

### **Available HTTP Methods**

```dart
final api = ApiService();

// GET
final data = await api.get('/products/');

// POST
final response = await api.post('/login', body: {
  'email': 'user@test.com',
  'password': 'password'
});

// PUT (Full update)
await api.put('/products/1/', body: {
  'name': 'New Name',
  'price': 99.99,
});

// PATCH (Partial update)
await api.patch('/products/1/', body: {
  'price': 99.99,
});

// DELETE
await api.delete('/products/1/');
```

### **Query Parameters**

```dart
// Add filters to URL
final filtered = await api.get(
  '/products/',
  queryParams: {
    'page': 1,
    'limit': 10,
    'sort': 'name',
  },
);
// URL becomes: /products/?page=1&limit=10&sort=name
```

### **Custom Headers**

```dart
// Add extra headers
await api.get(
  '/products/',
  extraHeaders: {
    'X-Custom-Header': 'value',
    'Authorization': 'Bearer token',
  },
);
```

### **File Upload**

```dart
// Multipart file upload
await api.multipartPost(
  '/upload/',
  files: [File('/path/to/image.jpg')],
  fields: {
    'title': 'My Image',
    'description': 'Image description',
  },
);
```

---

## 🛣️ API Endpoints

Centralized endpoint definitions.

### **Location:** `lib/services/api_endpoints.dart`

```dart
class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Product endpoints
  static const String products = '/products/';
  
  // User endpoints
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  
  // Dynamic endpoints (with parameters)
  static String productById(int id) => '/products/$id/';
  static String userProducts(int userId) => '/users/$userId/products/';
}
```

### **Using Endpoints**

```dart
// Simple endpoint
final products = await api.get(ApiEndpoints.products);

// Dynamic endpoint
final user = await api.get(ApiEndpoints.userById(123));

// In controller
final response = await api.post(
  ApiEndpoints.login,
  body: {'email': 'user@test.com', 'password': '123'},
);
```

---

## 🧪 Example API Calls

### **Login API Call**

```dart
class LoginController extends BaseController {
  final _api = ApiService();
  
  Future<void> login(String email, String password) async {
    final result = await apiCall<LoginResponse>(
      () async {
        final data = await _api.post(
          ApiEndpoints.login,
          body: {
            'email': email,
            'password': password,
          },
        );
        return LoginResponse.fromJson(data as Map<String, dynamic>);
      },
      showLoading: true,
      handleError: true,
    );

    if (result != null) {
      // Save token
      await StorageService().saveToken(result.data?.access ?? '');
      // Navigate
      Get.offAllNamed(AppRoutes.products);
    }
  }
}
```

### **Get List of Items**

```dart
class ProductsController extends BaseController {
  final _api = ApiService();
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await apiCall<List<dynamic>>(
      () async {
        final data = await _api.get(ApiEndpoints.products);
        return (data as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
      showLoading: true,
    );

    if (result != null) {
      products.value = result;
    }
  }
}
```

### **Create Item (POST)**

```dart
Future<void> createProduct(String name, double price) async {
  final result = await apiCall<ProductModel>(
    () async {
      final data = await _api.post(
        ApiEndpoints.products,
        body: {
          'name': name,
          'price': price,
        },
      );
      return ProductModel.fromJson(data as Map<String, dynamic>);
    },
  );

  if (result != null) {
    products.add(result);  // Add to local list
    ErrorHandler.showSnackbar('Product created', isError: false);
  }
}
```

### **Update Item (PUT)**

```dart
Future<void> updateProduct(int id, String name) async {
  await apiCall(
    () => _api.put(
      ApiEndpoints.productById(id),
      body: {'name': name},
    ),
  );

  // Update local list
  final index = products.indexWhere((p) => p.id == id);
  if (index >= 0) {
    products[index].name = name;
  }
}
```

### **Delete Item (DELETE)**

```dart
Future<void> deleteProduct(int id) async {
  await apiCall(
    () => _api.delete(ApiEndpoints.productById(id)),
    handleError: true,
  );

  // Remove from local list
  products.removeWhere((p) => p.id == id);
  ErrorHandler.showSnackbar('Product deleted', isError: false);
}
```

---

## ⚠️ Error Handling

All API errors are caught and returned as `ApiException`.

### **ApiException**

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isUnauthorized;
  
  ApiException({
    required this.message,
    this.statusCode,
    this.isUnauthorized = false,
  });
}
```

### **Common Status Codes**

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Use data |
| 400 | Bad Request | Show error to user |
| 401 | Unauthorized | Redirect to login |
| 403 | Forbidden | Show "access denied" |
| 404 | Not Found | Show "not found" |
| 500 | Server Error | Show "try again later" |

### **Handling 401 Unauthorized**

```dart
// In apiCall, catches automatically
try {
  final response = await _api.get('/data');
} on ApiException catch (e) {
  if (e.isUnauthorized) {
    // Clear token
    await StorageService().clearToken();
    // Redirect to login
    Get.offAllNamed(AppRoutes.login);
  }
}
```

### **Custom Error Handling**

```dart
// Show custom error dialog
final result = await apiCall<Data>(
  () async { ... },
  handleError: false,  // Don't auto-show error
  onError: (error) {
    // Custom handling
    if (error.statusCode == 401) {
      logoutUser();
    } else {
      showCustomErrorDialog(error.message);
    }
  },
);
```

---

## 🔐 Authentication

Automatic token injection in headers.

### **How It Works**

```dart
// ApiService automatically adds token to every request
Map<String, String> get _headers {
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  
  // Get saved token
  final token = _storage.getToken();
  if (token != null && token.isNotEmpty) {
    // Add to header
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}
```

### **Saving Token After Login**

```dart
// After successful login
final response = LoginResponse.fromJson(data);
await StorageService().saveToken(response.data?.access ?? '');
// Now automatically added to all requests
```

### **Clearing Token On Logout**

```dart
// On logout
await StorageService().clearToken();
Get.offAllNamed(AppRoutes.login);
// Token removed from all future requests
```

---

## 🔄 Pagination Example

Loading more items when scrolling.

```dart
class ProductsController extends BaseController {
  final products = <ProductModel>[].obs;
  int _currentPage = 1;
  final _pageSize = 10;
  bool _hasMore = true;

  Future<void> loadMore() async {
    if (!_hasMore) return;  // No more items

    final result = await apiCall<List<ProductModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.products,
          queryParams: {
            'page': _currentPage,
            'limit': _pageSize,
          },
        );
        return (data as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
      },
      showLoading: _currentPage == 1,  // Show spinner only for first load
    );

    if (result != null) {
      if (result.isEmpty) {
        _hasMore = false;  // No more items
      } else {
        products.addAll(result);
        _currentPage++;
      }
    }
  }
}
```

### **Detect End of List**

```dart
// In UI
ListView.builder(
  itemCount: controller.products.length + 1,
  itemBuilder: (context, index) {
    // Load more when near end
    if (index == controller.products.length - 5) {
      controller.loadMore();
    }
    
    if (index == controller.products.length) {
      return controller.hasMore
          ? LoadingWidget()
          : SizedBox.shrink();
    }
    
    return ProductCard(product: controller.products[index]);
  },
)
```

---

## 🌐 Environment Configuration

Different API URLs for different environments.

```dart
// lib/core/config/environment.dart
enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static late String baseUrl;
  static late int timeout;

  static void init(Environment env) {
    switch (env) {
      case Environment.dev:
        baseUrl = 'https://api.dev.example.com';
        timeout = 30;
        break;
      case Environment.staging:
        baseUrl = 'https://api.staging.example.com';
        timeout = 30;
        break;
      case Environment.prod:
        baseUrl = 'https://api.example.com';
        timeout = 30;
        break;
    }
  }
}

// In main.dart
void main() async {
  EnvironmentConfig.init(Environment.dev);  // Set environment
  runApp(MyApp());
}
```

---

## ✅ API Checklist

- [ ] Define all endpoints in `ApiEndpoints` class
- [ ] Use `ApiService` for all API calls
- [ ] Extend `BaseController` for automatic error handling
- [ ] Use `apiCall<T>()` wrapper for simple code
- [ ] Handle `ApiException` for 401 errors
- [ ] Save token after login
- [ ] Clear token on logout
- [ ] Use query params for filtering/pagination
- [ ] Test all error scenarios

---

## 📚 Next Steps

- 👉 [**STATE_MANAGEMENT.md**](STATE_MANAGEMENT.md) - Create controllers
- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - See full examples
- 👉 [**ADD_FEATURES.md**](ADD_FEATURES.md) - Add new features

---

**Remember:** All API calls go through `ApiService` - never use `http` package directly!
