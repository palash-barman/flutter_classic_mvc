# 💻 CODE EXAMPLES - Real-World Patterns

Copy-paste ready code examples for common scenarios.

---

## **Example 1: Product Listing Page**

Complete working example with loading/error/empty states.

### **Model**
```dart
class Product {
  final int id;
  final String name;
  final String price;
  
  Product({required this.id, required this.name, required this.price});
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}
```

### **Controller**
```dart
class ProductsController extends BaseController {
  final products = <Product>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }
  
  Future<void> loadProducts() async {
    final result = await apiCall<List<Product>>(
      () async {
        final data = await _api.get('/products/');
        return (data as List).map((p) => Product.fromJson(p)).toList();
      },
      showLoading: true,
    );
    
    if (result != null) {
      products.value = result;
    }
  }
}
```

### **Page**
```dart
class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingWidget();
        }
        
        if (controller.hasError.value) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadProducts,
          );
        }
        
        if (controller.products.isEmpty) {
          return EmptyWidget(message: 'No products');
        }
        
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (_, i) => ProductCard(
            product: controller.products[i],
          ),
        );
      }),
    );
  }
}
```

---

## **Example 2: Login Form**

Complete authentication example.

### **Controller**
```dart
class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController(text: 'user@test.com');
  final passwordCtrl = TextEditingController(text: 'StrongPass123!');
  final obscurePassword = true.obs;
  
  final _api = ApiService();
  final _storage = StorageService();
  
  void togglePasswordVisibility() => obscurePassword.toggle();
  
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    
    final result = await apiCall<LoginResponse>(
      () async {
        final data = await _api.post(
          '/auth/login/',
          body: {
            'email': emailCtrl.text.trim(),
            'password': passwordCtrl.text,
          },
        );
        return LoginResponse.fromJson(data);
      },
      showLoading: true,
    );
    
    if (result != null) {
      await _storage.saveToken(result.data?.access ?? '');
      Get.offAllNamed(AppRoutes.products);
    }
  }
  
  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
```

### **Page**
```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: controller.emailCtrl,
                labelText: 'Email',
                isEmail: true,
                checkEmpty: true,
              ),
              SizedBox(height: 16),
              Obx(() => CustomTextField(
                controller: controller.passwordCtrl,
                labelText: 'Password',
                isPassword: !controller.obscurePassword.value,
                checkEmpty: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
              SizedBox(height: 32),
              Obx(() => CustomButton(
                onTap: controller.login,
                text: 'Login',
                loading: controller.isLoading.value,
                width: double.infinity,
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

## **Example 3: Search with Debounce**

Search with API call delay.

### **Controller**
```dart
class SearchController extends BaseController {
  final searchResults = <Item>[].obs;
  final searchQuery = ''.obs;
  Timer? _debounce;
  
  void search(String query) {
    searchQuery.value = query;
    _debounce?.cancel();
    
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    
    _debounce = Timer(Duration(milliseconds: 500), () async {
      await apiCall<List<Item>>(
        () async {
          final data = await _api.get(
            '/search/',
            queryParams: {'q': query},
          );
          return (data as List).map((i) => Item.fromJson(i)).toList();
        },
        showLoading: true,
      ).then((result) {
        if (result != null) {
          searchResults.value = result;
        }
      });
    });
  }
  
  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
```

### **Page**
```dart
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchController());
    
    return Scaffold(
      appBar: AppBar(
        title: CustomTextField(
          hintText: 'Search items...',
          onChanged: controller.search,
        ),
      ),
      body: Obx(() {
        if (controller.searchQuery.isEmpty) {
          return Center(child: Text('Enter search term'));
        }
        
        if (controller.isLoading.value) {
          return LoadingWidget();
        }
        
        if (controller.searchResults.isEmpty) {
          return EmptyWidget(message: 'No results found');
        }
        
        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (_, i) => ItemCard(
            item: controller.searchResults[i],
          ),
        );
      }),
    );
  }
}
```

---

## **Example 4: Pull-to-Refresh**

Refresh data by pulling down.

### **Page**
```dart
class RefreshPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataController());
    
    return Scaffold(
      appBar: AppBar(title: Text('Refresh Example')),
      body: Obx(() => RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: controller.isLoading.value
            ? LoadingWidget()
            : ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (_, i) => ItemCard(
                  item: controller.items[i],
                ),
              ),
      )),
    );
  }
}
```

---

## **Example 5: Pagination**

Load more items automatically when scrolling.

### **Controller**
```dart
class PaginatedController extends BaseController {
  final items = <Item>[].obs;
  int _page = 1;
  bool _hasMore = true;
  
  @override
  void onInit() {
    super.onInit();
    loadMore();
  }
  
  Future<void> loadMore() async {
    if (!_hasMore) return;
    
    final result = await apiCall<List<Item>>(
      () async {
        final data = await _api.get(
          '/items/',
          queryParams: {'page': _page, 'limit': 10},
        );
        return (data as List).map((i) => Item.fromJson(i)).toList();
      },
      showLoading: _page == 1,
    );
    
    if (result != null) {
      if (result.isEmpty) _hasMore = false;
      else {
        items.addAll(result);
        _page++;
      }
    }
  }
}
```

### **Page**
```dart
class PaginatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaginatedController());
    
    return Scaffold(
      appBar: AppBar(title: Text('Items')),
      body: Obx(() => ListView.builder(
        itemCount: controller.items.length + 1,
        itemBuilder: (_, i) {
          if (i == controller.items.length - 5) {
            controller.loadMore();
          }
          
          if (i == controller.items.length) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            );
          }
          
          return ItemCard(item: controller.items[i]);
        },
      )),
    );
  }
}
```

---

## **Example 6: Create/Update/Delete (CRUD)**

Complete CRUD operations.

### **Controller**
```dart
class CRUDController extends BaseController {
  final items = <Item>[].obs;
  
  // CREATE
  Future<void> create(String name) async {
    final result = await apiCall<Item>(
      () => _api.post('/items/', body: {'name': name}),
    );
    if (result != null) items.add(result);
  }
  
  // READ
  Future<void> loadItems() async {
    final result = await apiCall<List<Item>>(
      () async {
        final data = await _api.get('/items/');
        return (data as List).map((i) => Item.fromJson(i)).toList();
      },
      showLoading: true,
    );
    if (result != null) items.value = result;
  }
  
  // UPDATE
  Future<void> update(int id, String name) async {
    await apiCall(
      () => _api.put('/items/$id/', body: {'name': name}),
    );
    final idx = items.indexWhere((i) => i.id == id);
    if (idx >= 0) items[idx].name = name;
  }
  
  // DELETE
  Future<void> delete(int id) async {
    await apiCall(() => _api.delete('/items/$id/'));
    items.removeWhere((i) => i.id == id);
  }
}
```

---

## **Example 7: File Upload**

Upload image files.

### **Controller**
```dart
class UploadController extends BaseController {
  Future<void> uploadImage(File image) async {
    final result = await apiCall<UploadResponse>(
      () async {
        final data = await _api.multipartPost(
          '/upload/',
          files: [image],
          fields: {'type': 'avatar'},
        );
        return UploadResponse.fromJson(data);
      },
      showLoading: true,
    );
    
    if (result != null) {
      ErrorHandler.showSnackbar('Upload successful', isError: false);
    }
  }
}
```

### **Page**
```dart
class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadController());
    
    return Scaffold(
      appBar: AppBar(title: Text('Upload')),
      body: Center(
        child: CustomImagePicker(
          onImageSelected: controller.uploadImage,
        ),
      ),
    );
  }
}
```

---

## ✅ Example Checklist

- [ ] Simple list loading
- [ ] Login/authentication
- [ ] Search with debounce
- [ ] Pull-to-refresh
- [ ] Pagination
- [ ] CRUD operations
- [ ] File upload

---

## 📚 Next Steps

- 👉 [**PATTERNS.md**](PATTERNS.md) - More patterns
- 👉 [**ADD_FEATURES.md**](ADD_FEATURES.md) - Create features
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Follow standards

---

**Copy these examples and adapt to your needs!**
