# 🎮 STATE MANAGEMENT - Creating Controllers

How to create and use controllers for state management.

---

## 📝 Creating Your First Controller

```dart
// lib/controllers/my_feature_controller.dart
import 'package:get/get.dart';
import 'package:flutter_classic_mvc/core/base/base_controller.dart';

class MyFeatureController extends BaseController {
  // 1. State variables (reactive)
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;
  final items = <MyItem>[].obs;
  
  // 2. Regular variables (not reactive, but ok for simple data)
  int _currentPage = 1;
  bool _hasMore = true;
  
  // 3. Dependencies
  final _api = ApiService();
  final _storage = StorageService();
  
  // 4. TextEditingControllers for forms
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;

  // 5. Lifecycle - Initialize
  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController();
    descCtrl = TextEditingController();
    loadItems();
  }

  // 6. Lifecycle - Ready (optional)
  @override
  void onReady() {
    super.onReady();
    // Called after first frame rendered
  }

  // 7. Core methods
  Future<void> loadItems() async {
    final result = await apiCall<List<MyItem>>(
      () async {
        final data = await _api.get('/my-items/');
        return (data as List)
            .map((item) => MyItem.fromJson(item))
            .toList();
      },
      showLoading: true,
    );

    if (result != null) {
      items.value = result;
      _currentPage = 1;
      _hasMore = true;
    }
  }

  void addItem(MyItem item) => items.add(item);
  
  void removeItem(int index) => items.removeAt(index);
  
  void updateItem(int index, MyItem newItem) => items[index] = newItem;

  // 8. Cleanup
  @override
  void onClose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }
}
```

---

## 🔧 Common Patterns

### **Pattern 1: Simple Data Loading**

```dart
class ItemsController extends BaseController {
  final items = <Item>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    final result = await apiCall<List<Item>>(
      () async {
        final data = await _api.get('/items/');
        return (data as List).map((i) => Item.fromJson(i)).toList();
      },
      showLoading: true,
    );

    if (result != null) {
      items.value = result;
    }
  }
}
```

### **Pattern 2: Form Submission**

```dart
class FormController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final result = await apiCall<SubmitResponse>(
      () => _api.post('/submit', body: {
        'email': emailCtrl.text,
        'password': passwordCtrl.text,
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
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
```

### **Pattern 3: Search with Debounce**

```dart
class SearchController extends BaseController {
  final searchResults = <SearchResult>[].obs;
  final searchQuery = ''.obs;
  Timer? _debounce;

  void search(String query) {
    searchQuery.value = query;
    
    // Cancel previous timer
    _debounce?.cancel();
    
    // Debounce 500ms
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        searchResults.clear();
        return;
      }

      await apiCall<List<SearchResult>>(
        () => _api.get(
          '/search/',
          queryParams: {'q': query},
        ),
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

### **Pattern 4: Pagination**

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
      showLoading: _page == 1,  // Only show spinner on first load
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

### **Pattern 5: CRUD Operations**

```dart
class CRUDController extends BaseController {
  final items = <Item>[].obs;

  // CREATE
  Future<void> createItem(String name) async {
    final result = await apiCall<Item>(
      () => _api.post('/items/', body: {'name': name}),
    );
    if (result != null) {
      items.add(result);
      ErrorHandler.showSnackbar('Created', isError: false);
    }
  }

  // READ (already in loadItems)
  Future<void> loadItems() async {
    final result = await apiCall<List<Item>>(
      () async {
        final data = await _api.get('/items/');
        return (data as List).map((i) => Item.fromJson(i)).toList();
      },
    );
    if (result != null) items.value = result;
  }

  // UPDATE
  Future<void> updateItem(int id, String name) async {
    await apiCall(
      () => _api.put('/items/$id/', body: {'name': name}),
    );
    final index = items.indexWhere((i) => i.id == id);
    if (index >= 0) items[index].name = name;
  }

  // DELETE
  Future<void> deleteItem(int id) async {
    await apiCall(
      () => _api.delete('/items/$id/'),
    );
    items.removeWhere((i) => i.id == id);
  }
}
```

---

## 🔗 Using Controllers in UI

### **Basic Usage**

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get or create controller
    final controller = Get.put(MyController());

    return Scaffold(
      appBar: AppBar(title: Text('My Feature')),
      body: Obx(() {
        // Automatically rebuilds when obs variables change
        if (controller.isLoading.value) {
          return LoadingWidget();
        }

        if (controller.hasError.value) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadItems,
          );
        }

        if (controller.items.isEmpty) {
          return EmptyWidget();
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (_, i) => ItemCard(
            item: controller.items[i],
          ),
        );
      }),
    );
  }
}
```

### **With Form**

```dart
class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FormController());

    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: controller.emailCtrl,
                labelText: 'Email',
                isEmail: true,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordCtrl,
                labelText: 'Password',
                isPassword: true,
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

### **With Search**

```dart
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchController());

    return Scaffold(
      appBar: AppBar(
        title: CustomTextField(
          hintText: 'Search...',
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
          return EmptyWidget(message: 'No results');
        }

        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (_, i) => ResultCard(
            result: controller.searchResults[i],
          ),
        );
      }),
    );
  }
}
```

---

## 🎯 Lifecycle Methods

```dart
class MyController extends BaseController {
  @override
  void onInit() {
    super.onInit();
    // Called when controller created
    print('1. Controller created');
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
    // Called when first frame rendered (UI ready)
    print('2. UI ready');
  }

  // Active period... UI interactions, API calls, etc

  @override
  void onClose() {
    super.onClose();
    // Called when controller destroyed
    print('3. Controller destroyed - cleanup here');
    cancelRequests();
  }
}
```

---

## 🔍 Debugging State

### **Check if controller exists**

```dart
if (Get.isRegistered<MyController>()) {
  print('Controller registered');
}
```

### **Log observable changes**

```dart
final items = <Item>[].obs;

ever(items, (newList) {
  print('Items changed: $newList');
});
```

### **Watch for updates**

```dart
once(items, (newList) {
  print('First change: $newList');
});
```

---

## ✅ Controller Checklist

- [ ] Extend `BaseController`
- [ ] Create `.obs` variables for state
- [ ] Initialize in `onInit()`
- [ ] Dispose resources in `onClose()`
- [ ] Use `apiCall<T>()` for API calls
- [ ] Use `Obx()` in UI to listen
- [ ] Upload state in UI, not controller
- [ ] Validate input before API calls
- [ ] Handle all error cases

---

## 📚 Next Steps

- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - Full controller examples
- 👉 [**ADD_FEATURES.md**](ADD_FEATURES.md) - Create features
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Coding standards

---

**Key Rule:** Every`.obs` change triggers `Obx()` rebuild. Use wisely!
