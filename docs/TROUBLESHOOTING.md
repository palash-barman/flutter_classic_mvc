# 🐛 TROUBLESHOOTING - Common Issues & Solutions

Solutions for 10+ common problems.

---

## **Problem 1: "Controller not found" Error**

### **Error Message**
```
Get.find<MyController>()
throws "Could not find controller"
```

### **Cause**
Controller is not registered before use.

### **Solution**

**Option 1: Register in GlobalBindings**
```dart
// lib/core/global/global_bindings.dart
class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MyController(), permanent: true);
  }
}

// In main.dart
GetMaterialApp(
  initialBinding: GlobalBindings(),
  ...
)
```

**Option 2: Register in route**
```dart
GetPage(
  name: AppRoutes.myPage,
  page: () {
    Get.put(MyController());  // Register here
    return MyPage();
  },
)
```

**Option 3: Register in page**
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyController());  // Register here
    return Scaffold(...);
  }
}
```

---

## **Problem 2: UI Not Rebuilding**

### **Symptom**
Widget doesn't update when observable changes.

### **Cause**
Not using `Obx()` wrapper or not using `.obs` variables.

### **Solution**

❌ **Wrong:**
```dart
// Missing Obx()
if (controller.isLoading.value) {
  return LoadingWidget();
}
```

✅ **Correct:**
```dart
// Wrapped in Obx()
Obx(() {
  if (controller.isLoading.value) {
    return LoadingWidget();
  }
  return DataWidget();
})
```

---

## **Problem 3: Memory Leak - Resources Not Cleaned**

### **Symptom**
Yellow warnings in console about disposed controllers.

### **Cause**
Not disposing resources in `onClose()`.

### **Solution**

```dart
class MyController extends BaseController {
  late TextEditingController emailCtrl;
  late StreamSubscription _subscription;
  Timer? _timer;
  
  @override
  void onInit() {
    super.onInit();
    emailCtrl = TextEditingController();
    _subscription = stream.listen(...);
    _timer = Timer.periodic(...);
  }
  
  @override
  void onClose() {
    emailCtrl.dispose();      // Required!
    _subscription.cancel();   // Required!
    _timer?.cancel();         // Required!
    super.onClose();
  }
}
```

---

## **Problem 4: 401 Unauthorized Loop**

### **Error**
Keep getting 401 errors, can't login.

### **Cause**
Token not being saved or auto-added to requests.

### **Solution**

**Step 1: Save token after login**
```dart
final response = LoginResponse.fromJson(data);
await StorageService().saveToken(response.data?.access ?? '');
```

**Step 2: Verify ApiService adds token**
```dart
// lib/services/api_service.dart
Map<String, String> get _headers {
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  
  final token = _storage.getToken();
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';  // Check this!
  }
  return headers;
}
```

**Step 3: Clear token on 401**
```dart
// In ApiService._request()
if (response.statusCode == 401) {
  await _storage.clearToken();
  Get.offAllNamed(AppRoutes.login);
}
```

---

## **Problem 5: JSON Parsing Error**

### **Error**
```
type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'List<dynamic>'
```

### **Cause**
API response format doesn't match model.

### **Solution**

**Check API response:**
```bash
# Check what API actually returns
curl https://api.example.com/products/ | jq
```

**Update model parsing:**
```dart
// If API returns: { "data": [...] }
factory MyModel.fromJson(Map<String, dynamic> json) {
  return MyModel(
    items: (json['data'] as List)  // Parse 'data' field
        .map((i) => ItemModel.fromJson(i))
        .toList(),
  );
}

// If API returns: [...]
factory MyModel.fromJson(List<dynamic> json) {
  return MyModel(
    items: json.map((i) => ItemModel.fromJson(i)).toList(),
  );
}
```

---

## **Problem 6: "Bad state: No elements" Error**

### **Error**
```
StateError: Bad state: No elements
```

### **Cause**
Accessing empty list without checking.

### **Solution**

```dart
❌ WRONG:
final first = items[0];  // Crashes if empty!

✅ CORRECT:
final first = items.isNotEmpty ? items[0] : null;

// Or use safe navigation
final first = items.firstOrNull;

// Or check before using
if (items.isNotEmpty) {
  doSomething(items[0]);
}
```

---

## **Problem 7: Loading Never Stops**

### **Symptom**
Loading spinner visible forever.

### **Cause**
Forgot to set `isLoading.value = false` or error not caught.

### **Solution**

```dart
// Use apiCall() - auto handles loading
final result = await apiCall<Data>(
  () => _api.get('/data'),
  showLoading: true,  // Auto shows/hides
);

// Or manual (less recommended)
Future<void> loadData() async {
  try {
    isLoading.value = true;
    final data = await _api.get('/data');
    process(data);
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;  // MUST set to false
  }
}
```

---

## **Problem 8: Can't Update List Items**

### **Symptom**
Update item but UI doesn't reflect change.

### **Cause**
Modifying object but not refreshing list.

### **Solution**

```dart
// ❌ WRONG - Object updated but list doesn't know
items[0].name = 'New Name';

// ✅ CORRECT - Refresh list after update
items[0].name = 'New Name';
items.refresh();  // Tell list to rebuild

// Or reassign entire item
items[0] = updatedItem;
items.refresh();

// Or use list operations
items.replaceRange(0, 1, [updatedItem]);
```

---

## **Problem 9: Form Validation Not Working**

### **Symptom**
Form submits with invalid data.

### **Cause**
Validator not set or not checked before submit.

### **Solution**

```dart
class FormController extends BaseController {
  final formKey = GlobalKey<FormState>();
  
  Future<void> submit() async {
    // ✅ MUST validate before submit
    if (!formKey.currentState!.validate()) {
      return;  // Don't proceed if invalid
    }
    
    // Proceed with submission
    await submitToApi();
  }
}

// In UI
Form(
  key: controller.formKey,
  child: Column(
    children: [
      CustomTextField(
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Required';
          return null;
        },
      ),
    ],
  ),
)
```

---

## **Problem 10: Debounce Timer Causing Issues**

### **Symptom**
Search/filter triggering multiple times.

### **Solution**

```dart
class SearchController extends BaseController {
  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();  // ✅ Cancel previous timer
    
    _debounce = Timer(Duration(milliseconds: 500), () {
      performSearch(query);
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();  // ✅ Cancel on dispose
    super.onClose();
  }
}
```

---

## **Problem 11: Navigation Not Working**

### **Error**
`Get.toNamed()` does nothing.

### **Cause**
Route not registered or wrong route name.

### **Solution**

**Step 1: Register route**
```dart
// lib/routes/app_pages.dart
static final pages = <GetPage>[
  GetPage(
    name: AppRoutes.myPage,  // Must match
    page: () => MyPage(),
  ),
];
```

**Step 2: Use exact route name**
```dart
// In main.dart
GetMaterialApp(
  getPages: AppPages.pages,  // Must add pages
)

// In page
Get.toNamed(AppRoutes.myPage);  // Must match exactly
```

**Step 3: Check route constants**
```dart
// lib/routes/app_routes.dart
class AppRoutes {
  static const String myPage = '/my-page';  // With / prefix!
}
```

---

## **Problem 12: API Calls Cached/Not Updating**

### **Symptom**
API returns old data, doesn't refresh.

### **Cause**
Response is cached or endpoint wrong.

### **Solution**

```dart
// Add cache-busting query parameter
final data = await _api.get(
  '/products/',
  queryParams: {
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  },
);

// Or force refresh
Future<void> refresh() {
  items.clear();  // Clear cache
  loadItems();    // Reload
}
```

---

## **Debug Checklist**

When something breaks:

1. **Check console** - Look for full error message
2. **Run `flutter clean`** - Clear build cache
3. **Verify route registered** - Check app_pages.dart
4. **Check controller registered** - Use `Get.isRegistered<T>()`
5. **Verify API endpoint** - Test with curl/Postman
6. **Check network** - Is device connected?
7. **Check token** - Is token saved and valid?
8. **Check logic** - Is `if` condition correct?
9. **Add print statements** - Debug step by step
10. **Restart app** - Sometimes helps!

---

## **Common Command Line Fixes**

```bash
# Clean everything
flutter clean
flutter pub get

# Check for issues
flutter analyze

# Format code
dart format .

# Run with verbose output
flutter run -v

# See HTTP requests
# Add verbose logging in ApiService.dart

# Rebuild after changing models
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ✅ Troubleshooting Checklist

- [ ] Check full error message
- [ ] Run `flutter clean && flutter pub get`
- [ ] Verify routes registered
- [ ] Check controllers registered
- [ ] Validate API response format
- [ ] Check error handling
- [ ] Look for memory leaks
- [ ] Verify resource cleanup
- [ ] Test with debugger
- [ ] Check console logs

---

## 📚 Next Steps

- 👉 [**TESTING.md**](TESTING.md) - Write tests
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Follow standards
- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - See examples

---

**When stuck: Read error message carefully, check basics first!**
