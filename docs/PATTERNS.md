# 📋 PATTERNS - Common Architecture Patterns

Reusable design patterns for common scenarios.

---

## **Pattern 1: CRUD Operations**

Create, Read, Update, Delete operations.

```dart
class ItemController extends BaseController {
  final items = <Item>[].obs;
  
  // CREATE - Post new item
  Future<void> createItem(String name) async {
    final result = await apiCall<Item>(
      () => _api.post('/items/', body: {'name': name}),
    );
    if (result != null) {
      items.add(result);
      ErrorHandler.showSnackbar('Created', isError: false);
    }
  }

  // READ - Get all items
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

  // UPDATE - Modify item
  Future<void> updateItem(int id, String newName) async {
    await apiCall(
      () => _api.put('/items/$id/', body: {'name': newName}),
    );
    final index = items.indexWhere((i) => i.id == id);
    if (index >= 0) {
      items[index].name = newName;
      items.refresh();
    }
  }

  // DELETE - Remove item
  Future<void> deleteItem(int id) async {
    await apiCall(() => _api.delete('/items/$id/'));
    items.removeWhere((i) => i.id == id);
  }
}
```

---

## **Pattern 2: Authentication Flow**

Login, logout, and session management.

```dart
class AuthController extends BaseController {
  final isLoggedIn = false.obs;
  final user = Rxn<User>();
  final _storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = _storage.getToken();
    isLoggedIn.value = token != null && token.isNotEmpty;
    if (isLoggedIn.value) {
      await loadUserProfile();
    }
  }

  Future<void> login(String email, String password) async {
    final result = await apiCall<LoginResponse>(
      () async {
        final data = await _api.post('/auth/login/', body: {
          'email': email,
          'password': password,
        });
        return LoginResponse.fromJson(data);
      },
      showLoading: true,
    );

    if (result != null) {
      await _storage.saveToken(result.data?.access ?? '');
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.products);
    }
  }

  Future<void> logout() async {
    await _api.post('/auth/logout/');
    await _storage.clearToken();
    isLoggedIn.value = false;
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> loadUserProfile() async {
    final result = await apiCall<User>(
      () async {
        final data = await _api.get('/users/me/');
        return User.fromJson(data);
      },
    );
    if (result != null) user.value = result;
  }
}
```

---

## **Pattern 3: Error Boundary**

Handle all error states.

```dart
// In UI
Obx(() {
  // 1. Loading state
  if (controller.isLoading.value) {
    return LoadingWidget(message: 'Please wait...');
  }

  // 2. Error state
  if (controller.hasError.value) {
    return AppErrorWidget(
      message: controller.errorMessage.value,
      onRetry: controller.reload,
    );
  }

  // 3. Empty state
  if (controller.items.isEmpty) {
    return EmptyWidget(message: 'No data');
  }

  // 4. Success state
  return MainContent(items: controller.items);
})
```

---

## **Pattern 4: Search & Filter**

Search with debouncing.

```dart
class SearchController extends BaseController {
  final results = <Item>[].obs;
  final query = ''.obs;
  Timer? _debounce;

  void search(String text) {
    query.value = text;
    _debounce?.cancel();

    if (text.isEmpty) {
      results.clear();
      return;
    }

    _debounce = Timer(Duration(milliseconds: 500), () async {
      await apiCall<List<Item>>(
        () async {
          final data = await _api.get('/search/', 
            queryParams: {'q': text});
          return (data as List)
              .map((i) => Item.fromJson(i))
              .toList();
        },
        showLoading: true,
      ).then((result) {
        if (result != null) results.value = result;
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

---

## **Pattern 5: Pagination**

Load items in pages.

```dart
class PaginationController extends BaseController {
  final items = <Item>[].obs;
  int _page = 1;
  bool _hasMore = true;

  Future<void> loadMore() async {
    if (!_hasMore) return;

    final result = await apiCall<List<Item>>(
      () async {
        final data = await _api.get(
          '/items/',
          queryParams: {'page': _page, 'limit': 20},
        );
        return (data as List)
            .map((i) => Item.fromJson(i))
            .toList();
      },
      showLoading: _page == 1,
    );

    if (result != null) {
      if (result.isEmpty) {
        _hasMore = false;
      } else {
        items.addAll(result);
        _page++;
      }
    }
  }

  void refresh() {
    items.clear();
    _page = 1;
    _hasMore = true;
    loadMore();
  }
}
```

---

## **Pattern 6: Form Validation**

Validate and submit forms.

```dart
class FormController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final isValid = false.obs;

  void validateForm() {
    isValid.value = formKey.currentState?.validate() ?? false;
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final result = await apiCall<FormResponse>(
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
```

---

## **Pattern 7: Conditional Rendering**

Show/hide UI based on state.

```dart
class ConditionalController extends BaseController {
  final showDetails = false.obs;
  final item = Rxn<Item>();

  void toggleDetails() => showDetails.toggle();

  void selectItem(Item selectedItem) {
    item.value = selectedItem;
    showDetails.value = true;
  }
}

// In UI
Obx(() => Column(
  children: [
    ItemSummary(item: item.value!),
    if (showDetails.value)
      ItemDetails(item: item.value!),
  ],
))
```

---

## **Pattern 8: Refresh/Reload**

Pull-to-refresh pattern.

```dart
class RefreshController extends BaseController {
  final items = <Item>[].obs;

  Future<void> refreshData() async {
    final result = await apiCall<List<Item>>(
      () async {
        final data = await _api.get('/items/');
        return (data as List)
            .map((i) => Item.fromJson(i))
            .toList();
      },
      showLoading: false,  // Don't show spinner for refresh
    );

    if (result != null) {
      items.value = result;
      ErrorHandler.showSnackbar('Refreshed', isError: false);
    }
  }
}

// In UI
RefreshIndicator(
  onRefresh: controller.refreshData,
  child: ListView.builder(...),
)
```

---

## **Pattern 9: File Upload**

Upload files/images.

```dart
class FileController extends BaseController {
  final uploadedFile = Rxn<FileModel>();
  final uploadProgress = 0.obs;

  Future<void> uploadFile(File file) async {
    final result = await apiCall<FileModel>(
      () async {
        final data = await _api.multipartPost(
          '/files/upload/',
          files: [file],
          fields: {'type': 'document'},
        );
        return FileModel.fromJson(data);
      },
      showLoading: true,
    );

    if (result != null) {
      uploadedFile.value = result;
      ErrorHandler.showSnackbar('Uploaded', isError: false);
    }
  }
}
```

---

## **Pattern 10: Master-Detail**

Show list, then details on selection.

```dart
class MasterDetailController extends BaseController {
  final items = <Item>[].obs;
  final selectedItem = Rxn<Item>();

  void selectItem(Item item) => selectedItem.value = item;

  void clearSelection() => selectedItem.value = null;
}

// In UI
Scaffold(
  body: Row(
    children: [
      // Master list
      Flexible(
        flex: 1,
        child: ItemList(
          items: items,
          onSelect: controller.selectItem,
        ),
      ),
      // Detail panel
      Flexible(
        flex: 2,
        child: selectedItem.value != null
            ? ItemDetail(item: selectedItem.value!)
            : EmptyWidget(),
      ),
    ],
  ),
)
```

---

## ✅ Patterns Checklist

- [ ] CRUD operations
- [ ] Authentication
- [ ] Error boundaries
- [ ] Search & filter
- [ ] Pagination
- [ ] Form validation
- [ ] Conditional rendering
- [ ] Refresh/reload
- [ ] File upload
- [ ] Master-detail

---

## 📚 Next Steps

- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - Working examples
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Best practices
- 👉 [**TROUBLESHOOTING.md**](TROUBLESHOOTING.md) - Common issues

---

**Apply these patterns to solve most common scenarios!**
