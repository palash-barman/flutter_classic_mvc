# 🧪 TESTING - Unit & Widget Tests

Write tests for your code.

---

## **Unit Test Example**

Test controller logic.

```dart
// test/controllers/my_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_classic_mvc/controllers/my_controller.dart';
import 'package:flutter_classic_mvc/models/item_model.dart';

void main() {
  late MyController controller;

  setUp(() {
    // Create controller before each test
    controller = MyController();
  });

  test('Initial state is correct', () {
    // Verify initial state
    expect(controller.items.isEmpty, true);
    expect(controller.isLoading.value, false);
    expect(controller.hasError.value, false);
  });

  test('addItem adds item to list', () {
    // Create test item
    final item = Item(id: 1, name: 'Test');
    
    // Call method
    controller.addItem(item);
    
    // Assert result
    expect(controller.items.length, 1);
    expect(controller.items[0].name, 'Test');
  });

  test('removeItem removes from list', () {
    final item = Item(id: 1, name: 'Test');
    controller.items.add(item);
    
    controller.removeItem(0);
    
    expect(controller.items.isEmpty, true);
  });

  tearDown(() {
    // Cleanup after each test
    controller.onClose();
  });
}
```

---

## **Widget Test Example**

Test UI components.

```dart
// test/widgets/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_classic_mvc/views/base/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('renders with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Click Me',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('shows loading spinner when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Click',
              onTap: () {},
              loading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls onTap when clicked', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Click',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(tapped, true);
    });
  });
}
```

---

## **Mock API Service Test**

Test with mocked API.

```dart
// test/controllers/login_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_classic_mvc/controllers/login_controller.dart';
import 'package:flutter_classic_mvc/services/api_service.dart';

// Create mock
class MockApiService extends Mock implements ApiService {}

void main() {
  late LoginController controller;
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
    Get.put(mockApi);  // Register mock
    controller = LoginController();
  });

  test('login succeeds with valid credentials', () async {
    // Mock API response
    when(mockApi.post(any, body: anyNamed('body')))
        .thenAnswer((_) async => {
          'data': {'access': 'token123'},
          'message': 'Success'
        });

    // Call login
    await controller.login('test@example.com', 'password');

    // Verify
    expect(controller.isLoading.value, false);
    expect(controller.hasError.value, false);
  });

  test('login fails with invalid credentials', () async {
    // Mock API error
    when(mockApi.post(any, body: anyNamed('body')))
        .thenThrow(Exception('Invalid credentials'));

    // Call login
    await controller.login('test@example.com', 'wrong');

    // Verify error state
    expect(controller.hasError.value, true);
  });

  tearDown(() {
    controller.onClose();
  });
}
```

---

## **Form Validation Test**

Test form validation logic.

```dart
// test/utils/validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_classic_mvc/core/utils/app_validator.dart';

void main() {
  group('Email Validation', () {
    test('returns null for valid email', () {
      final result = AppValidator.validateEmail('user@example.com');
      expect(result, null);
    });

    test('returns error for empty email', () {
      final result = AppValidator.validateEmail('');
      expect(result, isNotNull);
    });

    test('returns error for invalid email', () {
      final result = AppValidator.validateEmail('notanemail');
      expect(result, isNotNull);
    });
  });

  group('Password Validation', () {
    test('returns null for strong password', () {
      final result = AppValidator.validatePassword('StrongPass123!');
      expect(result, null);
    });

    test('returns error for weak password', () {
      final result = AppValidator.validatePassword('123');
      expect(result, isNotNull);
    });
  });
}
```

---

## **Running Tests**

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/controllers/my_controller_test.dart

# Run with coverage
flutter test --coverage

# Run only unit tests (skip widget tests)
flutter test test/unit/

# Run tests in watch mode
flutter test --watch

# Run with verbose output
flutter test -v
```

---

## **Test Best Practices**

### **1. One assertion per test**

```dart
// ✅ GOOD
test('adds item to list', () {
  controller.addItem(item);
  expect(controller.items.length, 1);
});

// ❌ BAD - Multiple assertions
test('manages items', () {
  controller.addItem(item);
  expect(controller.items.length, 1);
  
  controller.removeItem(0);
  expect(controller.items.length, 0);
  
  // Hard to know which assertion failed
});
```

### **2. Use descriptive test names**

```dart
// ✅ GOOD
test('returns null when email is valid', () { });
test('throws error when email is empty', () { });

// ❌ BAD
test('test1', () { });
test('validates', () { });
```

### **3. Follow Arrange-Act-Assert**

```dart
test('adds item correctly', () {
  // ARRANGE - Setup
  final item = Item(id: 1, name: 'Test');
  
  // ACT - Execute
  controller.addItem(item);
  
  // ASSERT - Verify
  expect(controller.items.contains(item), true);
});
```

---

## **Test Structure**

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Test group
  group('Feature', () {
    late MyClass instance;

    setUp(() {
      // Before each test
      instance = MyClass();
    });

    test('does something', () {
      // Test code
    });

    test('does something else', () {
      // Another test
    });

    tearDown(() {
      // After each test
      instance.dispose();
    });
  });
}
```

---

## **Common Test Patterns**

### **Test Async Code**

```dart
test('loads data successfully', () async {
  final result = await controller.loadData();
  expect(result, isNotNull);
});
```

### **Test Exceptions**

```dart
test('throws error on invalid input', () async {
  expect(
    () => controller.validate('invalid'),
    throwsException,
  );
});
```

### **Test State Changes**

```dart
test('updates loading state', () async {
  expect(controller.isLoading.value, false);
  
  controller.loadData();
  
  expect(controller.isLoading.value, true);
});
```

---

## **Test Coverage**

```bash
# Generate coverage report
flutter test --coverage

# View coverage
# Coverage files are in coverage/lcov.info
```

---

## ✅ Testing Checklist

- [ ] Unit tests for business logic
- [ ] Widget tests for UI components
- [ ] Mock external services
- [ ] Test error scenarios
- [ ] Test edge cases
- [ ] All tests passing
- [ ] Coverage > 80%

---

## **Setup pubspec.yaml for Testing**

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.3.0
  build_runner: ^2.3.0
```

---

## 📚 Next Steps

- 👉 [**BUILD_DEPLOYMENT.md**](BUILD_DEPLOYMENT.md) - Release builds
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Follow standards
- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - See examples

---

**Even simple tests catch lots of bugs!**
