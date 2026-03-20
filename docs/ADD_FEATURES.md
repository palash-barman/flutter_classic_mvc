# ➕ ADD FEATURES - Step-by-Step Guide

How to add a complete new feature to the app.

---

## 📋 7-Step Feature Creation

Follow this process to add ANY new feature.

---

## **Step 1: Plan API Endpoint**

Add the endpoint constant.

```dart
// lib/services/api_endpoints.dart
class ApiEndpoints {
  // ... existing endpoints
  
  // YOUR NEW FEATURE
  static const String myFeature = '/my-feature/';
  static String myFeatureById(int id) => '/my-feature/$id/';
  static String myFeatureByUserId(int userId) => '/users/$userId/features/';
}
```

---

## **Step 2: Create Data Model**

Define data structure and JSON parsing.

```dart
// lib/models/my_feature_model.dart
class MyFeatureModel {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  MyFeatureModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  // Parse JSON response
  factory MyFeatureModel.fromJson(Map<String, dynamic> json) {
    return MyFeatureModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Convert to JSON for requests
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };
}
```

---

## **Step 3: Create Controller**

Business logic and state management.

```dart
// lib/controllers/my_feature_controller.dart
import 'package:get/get.dart';
import 'package:flutter_classic_mvc/core/base/base_controller.dart';
import 'package:flutter_classic_mvc/models/my_feature_model.dart';
import 'package:flutter_classic_mvc/services/api_service.dart';
import 'package:flutter_classic_mvc/services/api_endpoints.dart';

class MyFeatureController extends BaseController {
  // State
  final items = <MyFeatureModel>[].obs;
  final selectedItem = Rxn<MyFeatureModel>();
  
  // Metadata
  int _currentPage = 1;
  bool _hasMore = true;
  
  // Dependencies
  final _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  // Load items from API
  Future<void> loadItems() async {
    final result = await apiCall<List<MyFeatureModel>>(
      () async {
        final data = await _api.get(ApiEndpoints.myFeature);
        return (data as List)
            .map((item) => MyFeatureModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
      showLoading: true,
    );

    if (result != null) {
      items.value = result;
    }
  }

  // Load more (pagination)
  Future<void> loadMore() async {
    if (!_hasMore) return;

    final result = await apiCall<List<MyFeatureModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.myFeature,
          queryParams: {'page': _currentPage},
        );
        return (data as List)
            .map((item) => MyFeatureModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
      showLoading: _currentPage == 1,
    );

    if (result != null) {
      if (result.isEmpty) {
        _hasMore = false;
      } else {
        items.addAll(result);
        _currentPage++;
      }
    }
  }

  // Create new item
  Future<void> createItem(String name, String description) async {
    final result = await apiCall<MyFeatureModel>(
      () async {
        final data = await _api.post(
          ApiEndpoints.myFeature,
          body: {
            'name': name,
            'description': description,
          },
        );
        return MyFeatureModel.fromJson(data as Map<String, dynamic>);
      },
      showLoading: true,
    );

    if (result != null) {
      items.add(result);
      ErrorHandler.showSnackbar('Created successfully', isError: false);
    }
  }

  // Update item
  Future<void> updateItem(int id, String name, String description) async {
    await apiCall(
      () => _api.put(
        ApiEndpoints.myFeatureById(id),
        body: {
          'name': name,
          'description': description,
        },
      ),
      showLoading: true,
    );

    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      items[index].name = name;
      items.refresh();
    }
  }

  // Delete item
  Future<void> deleteItem(int id) async {
    await apiCall(
      () => _api.delete(ApiEndpoints.myFeatureById(id)),
      showLoading: true,
    );

    items.removeWhere((item) => item.id == id);
    ErrorHandler.showSnackbar('Deleted', isError: false);
  }

  // Select item
  void selectItem(MyFeatureModel item) {
    selectedItem.value = item;
  }
}
```

---

## **Step 4: Create Reusable Widget (Optional)**

Create a card/item widget for displaying list items.

```dart
// lib/views/base/my_feature_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_classic_mvc/models/my_feature_model.dart';

class MyFeatureCard extends StatelessWidget {
  final MyFeatureModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MyFeatureCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                'Created: ${item.createdAt.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## **Step 5: Create Screen/Page**

The full screen/page users interact with.

```dart
// lib/views/screens/my_feature/my_feature_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_classic_mvc/controllers/my_feature_controller.dart';
import 'package:flutter_classic_mvc/views/base/loading_widget.dart';
import 'package:flutter_classic_mvc/views/base/error_widget.dart';
import 'package:flutter_classic_mvc/views/base/empty_widget.dart';
import 'package:flutter_classic_mvc/views/base/my_feature_card.dart';

class MyFeaturePage extends StatelessWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyFeatureController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Features'),
        elevation: 0,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading features...');
        }

        // Error state
        if (controller.hasError.value) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadItems,
          );
        }

        // Empty state
        if (controller.items.isEmpty) {
          return const EmptyWidget(
            message: 'No features yet',
            icon: Icons.feature_search,
          );
        }

        // Show list
        return RefreshIndicator(
          onRefresh: () => controller.loadItems(),
          child: ListView.builder(
            itemCount: controller.items.length + (controller._hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Load more when near end
              if (index == controller.items.length - 3) {
                controller.loadMore();
              }

              // Show loading at end
              if (index == controller.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              }

              final item = controller.items[index];
              return MyFeatureCard(
                item: item,
                onTap: () => _showDetailDialog(context, controller, item),
                onDelete: () => controller.deleteItem(item.id),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, MyFeatureController controller) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Feature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Feature name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty) {
                controller.createItem(nameCtrl.text, descCtrl.text);
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, MyFeatureController controller, MyFeatureModel item) {
    Get.dialog(
      AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:'),
            SizedBox(height: 8),
            Text(item.description),
            SizedBox(height: 16),
            Text('Created: ${item.createdAt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

---

## **Step 6: Add Routes**

Register the new page in routing.

```dart
// lib/routes/app_routes.dart
class AppRoutes {
  // ... existing routes
  static const String myFeature = '/my-feature';
}

// lib/routes/app_pages.dart
static final pages = <GetPage>[
  // ... existing pages
  
  GetPage(
    name: AppRoutes.myFeature,
    page: () {
      Get.put(MyFeatureController());
      return const MyFeaturePage();
    },
    middlewares: [AuthMiddleware()],  // Only for authenticated users
  ),
];
```

---

## **Step 7: Add Navigation Link**

Add a button or menu item to navigate to the new feature.

```dart
// In any page, add navigation
ElevatedButton(
  onPressed: () => Get.toNamed(AppRoutes.myFeature),
  child: const Text('Go to My Features'),
)

// Or in navigation drawer
ListTile(
  title: const Text('My Features'),
  leading: const Icon(Icons.feature_search),
  onTap: () => Get.toNamed(AppRoutes.myFeature),
)
```

---

## ✅ Feature Checklist

- [ ] Step 1: Added endpoint constant
- [ ] Step 2: Created model with fromJson/toJson
- [ ] Step 3: Created controller extending BaseController
- [ ] Step 4: Created reusable card widget
- [ ] Step 5: Created full page with Obx
- [ ] Step 6: Added route with middleware
- [ ] Step 7: Added navigation link
- [ ] Tested: Can create items
- [ ] Tested: Can read/list items
- [ ] Tested: Can update items
- [ ] Tested: Can delete items
- [ ] Tested: Error states
- [ ] Tested: Empty states
- [ ] Tested: Loading states

---

## 🎯 Quick Checklist (Copy-Paste)

```
lib/
├── models/my_feature_model.dart           ✓ Step 2
├── controllers/my_feature_controller.dart ✓ Step 3
├── views/base/my_feature_card.dart        ✓ Step 4
├── views/screens/my_feature/
│   └── my_feature_page.dart               ✓ Step 5
└── services/
    └── api_endpoints.dart                  ✓ Step 1 (added endpoint)

routes/
├── app_routes.dart                         ✓ Step 6 (added constant)
└── app_pages.dart                          ✓ Step 6 (added route)

Navigation: ✓ Step 7 (added link somewhere)
```

---

## 📚 Next Steps

- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - Full working examples
- 👉 [**PATTERNS.md**](PATTERNS.md) - Common patterns reference
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Follow standards

---

**Remember:** Follow these 7 steps for EVERY feature!
