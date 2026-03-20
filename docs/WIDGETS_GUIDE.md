# 🎨 WIDGETS GUIDE - Custom UI Components

All 11 custom reusable widgets built for the Classic MVC template with **real working code examples** from the project.

---

## **1. CustomButton** - Styled Button with Loading

Reusable button component with loading state, multiple styles, and built-in validation support.

### **Real Example from Project:**
📁 [lib/views/screens/auth/login_page.dart](../views/screens/auth/login_page.dart)

```dart
// From actual login page
Obx(
  () => CustomButton(
    onTap: () {
      if (controller.formKey.currentState!.validate()) {
        controller.login();
      }
    },
    text: "login".tr,
    loading: controller.isLoading.value,
    type: ButtonType.filled,
  ),
),
```

### **Properties & Usage**

```dart
CustomButton(
  onTap: () => {},              // Required - callback when tapped
  text: 'Click Me',             // Required - button text (use .tr for i18n)
  loading: false,               // Optional - shows spinner + disables tap
  loadingText: 'Loading',       // Optional - text shown while loading
  height: 50,                   // Optional - button height (default 50)
  width: double.infinity,       // Optional - button width
  radius: 24,                   // Optional - border radius (default 24)
  color: Colors.blue,           // Optional - background color
  textColor: Colors.white,      // Optional - text color
  type: ButtonType.filled,      // Optional - ButtonType.filled or .outlined
  margin: EdgeInsets.symmetric(horizontal: 16),
  elevation: 0,                 // Optional - shadow (default 0)
  icon: Icon(Icons.send),       // Optional - icon before text
)
```

### **More Examples**

```dart
// Outlined style
CustomButton(
  onTap: () => Get.back(),
  text: 'cancel'.tr,
  type: ButtonType.outlined,
  color: Colors.red,
);

// With icon and full width
CustomButton(
  onTap: () => controller.share(),
  text: 'Share Product',
  icon: Icon(Icons.share, color: Colors.white),
  width: double.infinity,
  margin: EdgeInsets.all(16),
);

// In a payment flow
Obx(() => CustomButton(
  onTap: controller.isLoading.value ? null : controller.checkout,
  text: 'Pay ${controller.totalPrice}',
  loading: controller.isLoading.value,
  loadingText: 'Processing...',
));
```

---

## **2. CustomTextField** - Advanced Text Input

Input field with built-in validation for email, password, and empty checks. Auto-validates format.

### **Real Example from Project:**
📁 [lib/views/screens/auth/login_page.dart](../views/screens/auth/login_page.dart)

```dart
// Email field with validation
CustomTextField(
  controller: controller.emailController,
  labelText: 'email'.tr,
  isEmail: true,  // ✅ Auto-validates email format
  prefixIcon: const Icon(Icons.email_outlined),
),
const SizedBox(height: 16),

// Password field with eye icon toggle
CustomTextField(
  controller: controller.passwordController,
  labelText: 'password'.tr,
  isPassword: true,  // ✅ Shows/hides password, adds eye icon
  prefixIcon: const Icon(Icons.lock_outlined),
),
```

### **Properties & Usage**

```dart
CustomTextField(
  controller: textController,          // Required - TextEditingController
  labelText: 'Full Name',              // Optional - top label
  hintText: 'Enter your name',         // Optional - placeholder text
  isPassword: false,                   // Optional - hide text + eye icon
  isEmail: false,                      // Optional - email regex validation
  checkEmpty: true,                    // Optional - empty field validation
  prefixIcon: Icon(Icons.person),      // Optional - icon on left
  suffixIcon: Icon(Icons.clear),       // Optional - icon on right
  fillColor: Colors.grey[100],         // Optional - background
  borderColor: Colors.grey,            // Optional - border color
  focusedBorderColor: Colors.blue,     // Optional - when focused
  borderRadius: 50,                    // Optional - corner radius (default 50)
  contentPaddingHorizontal: 20,        // Optional - left/right padding (default 20)
  contentPaddingVertical: 16,          // Optional - top/bottom padding (default 16)
  fontSize: 16,                        // Optional - text size (default 16)
  cursorColor: Colors.blue,            // Optional - cursor color
)
```

### **Validation Examples**

```dart
// Email validation (checks format automatically)
CustomTextField(
  controller: emailCtrl,
  labelText: 'Email Address',
  isEmail: true,  // Validates: format + checks if empty
  checkEmpty: true,
)

// Password field (with eye icon to toggle visibility)
CustomTextField(
  controller: passwordCtrl,
  labelText: 'Password',
  isPassword: true,  // Hides text, shows eye icon to toggle
)

// Simple name field (just empty check)
CustomTextField(
  controller: nameCtrl,
  labelText: 'Your Name',
  checkEmpty: true,  // Shows error if empty
)

// Search box without validation
CustomTextField(
  controller: searchCtrl,
  hintText: 'Search products...',
  prefixIcon: Icon(Icons.search),
  fillColor: Colors.grey[100],
)
```

---

## **3. CustomImage** - Smart Multi-Source Image Loader

Automatically detects image source (asset, network URL, local file, SVG) and loads accordingly.

### **Real Example from Project:**
📁 [lib/views/base/product_card.dart](../views/base/product_card.dart)

```dart
// Product image in card (from network URL)
CustomImage(
  path: "https://img.freepik.com/free-vector/white-product-podium-with-green-tropical-palm-leaves-golden-round-arch-green-wall_87521-3023.jpg",
  height: 200,
  width: double.infinity,
  borderRadius: BorderRadius.circular(8),
),
```

### **Properties & Usage**

```dart
CustomImage(
  path: 'assets/logo.png',           // Required - auto-detects source type
  width: 100,                        // Optional - image width (default 50)
  height: 100,                       // Optional - image height (default 50)
  borderRadius: BorderRadius.circular(8),  // Optional - rounded corners
  boxShape: BoxShape.rectangle,      // Optional - rectangle or circle
  fit: BoxFit.cover,                 // Optional - how to fit image (default cover)
  backgroundColor: Colors.grey,      // Optional - background color
  border: Border.all(width: 2),      // Optional - border around image
  colorFilter: ColorFilter.mode(...), // Optional - apply color overlay
)
```

### **Source Detection Examples**

```dart
// Network image (auto-detected by http/https)
CustomImage(
  path: 'https://example.com/product.jpg',
  height: 200,
  width: double.infinity,
)

// Asset image (auto-detected from assets/ folder)
CustomImage(
  path: 'assets/icons/app_logo.png',
  width: 80,
  height: 80,
)

// SVG file (auto-detected by .svg extension)
CustomImage(
  path: 'assets/vectors/heart.svg',
  width: 30,
  height: 30,
  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
)

// Local file from device storage
CustomImage(
  path: '/storage/emulated/0/Pictures/photo.jpg',
  width: 150,
  height: 150,
)

// Circular profile picture
CustomImage(
  path: 'https://randomuser.me/api/portraits/men/32.jpg',
  width: 100,
  height: 100,
  boxShape: BoxShape.circle,
  borderRadius: BorderRadius.circular(50),
  border: Border.all(color: Colors.blue, width: 2),
)

// Full-width banner with radius
CustomImage(
  path: 'https://example.com/banner.jpg',
  width: double.infinity,
  height: 250,
  borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(16),
  ),
)
```

---

## **4. ProductCard** - Product Display Card

Display product information with image, name, price, description, and owner.

### **Real Example from Project:**
📁 [lib/views/screens/products/products_page.dart](../views/screens/products/products_page.dart)

```dart
// Inside AppListView
AppListView(
  items: controller.products,
  isLoading: controller.isLoading.value,
  onLoadMore: controller.loadMoreProducts,
  item: (product) => ProductCard(product: product),  // ✅ Used here
)
```

### **Usage**

```dart
// Single product card
ProductCard(product: myProduct)

// In a list
ListView.builder(
  itemCount: controller.products.length,
  itemBuilder: (_, i) => ProductCard(
    product: controller.products[i],
  ),
)

// With custom spacing
Container(
  margin: EdgeInsets.all(8),
  child: ProductCard(product: product),
)
```

### **Data Model**

```dart
// ProductCard expects ProductModel with:
ProductModel(
  id: 1,
  name: 'iPhone 15 Pro',
  description: 'Latest Apple phone',
  price: '999.99',
  owner: 'Apple Store',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
)
```

---

## **5. ProfilePicture** - Editable Avatar Widget

Display and edit profile pictures with image picker integration.

### **Real Example from Project:**
📁 [lib/views/screens/profile/profile_page.dart](../views/screens/profile/profile_page.dart)

```dart
ProfilePicture(
  size: 120,
  imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
  imageFile: selectedImage,  // Local file if picked
  isEditable: true,  // ✅ Shows edit button
  onImagePicked: (file) {
    setState(() {
      selectedImage = file;  // Update with picked image
      debugPrint("Image saved: ${file.path}");
    });
  },
),
```

### **Properties & Usage**

```dart
ProfilePicture(
  size: 100,                          // Optional - width & height (default 100)
  imageUrl: 'https://...',            // Optional - network image URL
  imageFile: File('...'),             // Optional - local file path
  isEditable: false,                  // Optional - show edit button (default false)
  isCircular: true,                   // Optional - circular shape (default true)
  borderWidth: 2,                     // Optional - border thickness (default 2)
  borderColor: Colors.grey,           // Optional - border color
  onImagePicked: (file) => {},        // Optional - callback when image selected
  placeholderAsset: 'assets/...',     // Optional - placeholder if no image
)
```

### **Usage Examples**

```dart
// Display only
ProfilePicture(
  size: 80,
  imageUrl: user.profilePicture,
)

// With edit capability
ProfilePicture(
  size: 120,
  imageUrl: currentUser.avatar,
  isEditable: true,
  onImagePicked: (file) {
    // Save to storage or upload to API
    controller.updateProfilePicture(file);
  },
)

// With custom styling
ProfilePicture(
  size: 100,
  imageUrl: user.picture,
  isCircular: true,
  borderWidth: 3,
  borderColor: Colors.blue[500],
  onImagePicked: (pickedFile) {
    setState(() => selectedProfileImage = pickedFile);
  },
)
```

---

## **6. AppListView** - Generic Paginated List

Smart list view with pagination, refresh, pull-to-refresh, loading, and error states.

### **Real Example from Project:**
📁 [lib/views/screens/products/products_page.dart](../views/screens/products/products_page.dart)

```dart
// Full implementation with all features
AppListView(
  items: controller.products,           // Observable list
  isLoading: controller.isLoading.value,
  isLoadMore: controller.isLoadMore.value,
  hasMore: controller.hasMore.value,    // For infinite scroll
  hasError: controller.hasError.value,
  errorMessage: controller.errorMessage.value,
  onRefresh: controller.refreshProducts,  // Pull-to-refresh
  onLoadMore: controller.loadMoreProducts, // Infinite scroll
  item: (product) => ProductCard(product: product),  // Item builder
)
```

### **Properties & Usage**

```dart
AppListView<ProductModel>(
  items: products,                    // Required - list of items
  item: (p) => ProductCard(p),        // Required - widget for each item
  isLoading: false,                   // Optional - show loading
  isLoadMore: false,                  // Optional - loading more
  hasMore: true,                      // Optional - has more items
  hasError: false,                    // Optional - show error
  errorMessage: 'Failed to load',     // Optional - error text
  onRefresh: () async => {...},       // Optional - pull-to-refresh
  onLoadMore: () async => {...},      // Optional - load more on scroll
  itemBuilder: (ctx, item, idx) => {}, // Optional - custom builder
  loadingWidget: LoadingWidget(),     // Optional - custom loading
  emptyWidget: EmptyWidget(),         // Optional - custom empty
  errorWidget: (msg, retry) => {...}, // Optional - custom error
  reverse: false,                     // Optional - reverse list (default false)
  shrinkWrap: false,                  // Optional - shrink to content
  padding: EdgeInsets.all(8),         // Optional - list padding
)
```

### **Usage Examples**

```dart
// Simple list
AppListView(
  items: controller.users,
  item: (user) => UserTile(user: user),
)

// With infinite scroll
AppListView(
  items: controller.products,
  isLoadMore: controller.isLoadMore.value,
  hasMore: controller.hasMore.value,
  onLoadMore: controller.loadMore,
  item: (p) => ProductCard(product: p),
)

// Full featured
Obx(() => AppListView(
  items: controller.items,
  isLoading: controller.isLoading.value,
  isLoadMore: controller.isLoadMore.value,
  hasMore: controller.hasMore.value,
  hasError: controller.hasError.value,
  errorMessage: controller.errorMessage.value,
  onRefresh: controller.refresh,
  onLoadMore: controller.loadMore,
  item: (item) => ItemCard(item: item),
))
```

---

## **7. LoadingWidget** - Loading Spinner

Centered loading spinner with optional message.

```dart
// Basic
const LoadingWidget()

// With message
const LoadingWidget(message: 'Loading products...')

// Conditional usage
Obx(() {
  if (controller.isLoading.value) {
    return const LoadingWidget();
  }
  return DataWidget();
})
```

---

## **8. EmptyWidget** - Empty State

Display when no data available.

```dart
// Default
const EmptyWidget()

// Custom message
EmptyWidget(message: 'No products found')

// Custom icon
EmptyWidget(
  message: 'Cart is empty',
  icon: Icons.shopping_cart,
)

// Conditional
Obx(() => 
  controller.items.isEmpty 
    ? EmptyWidget(message: 'No items')
    : ListView(...)
)
```

---

## **9. AppErrorWidget** - Error State

Display errors with optional retry button.

```dart
// Basic
AppErrorWidget(message: 'Something went wrong')

// With retry
AppErrorWidget(
  message: 'Failed to load data',
  onRetry: () => controller.reload(),
)

// Conditional
Obx(() =>
  controller.hasError.value
    ? AppErrorWidget(
        message: controller.errorMessage.value,
        onRetry: controller.refetch,
      )
    : DataWidget()
)
```

---

## **10. NoInternetWidget** - No Connectivity

Display when offline.

```dart
// Basic
const NoInternetWidget()

// With retry
NoInternetWidget(
  onRetry: () => controller.retry(),
)

// Detect and show
Obx(() {
  if (!controller.hasInternet.value) {
    return const NoInternetWidget();
  }
  return DataWidget();
})
```

---

## **11. CustomImagePicker** - Image Selection Function

Function to pick and crop images from gallery or camera.

### **Real Example from Project:**
📁 [lib/views/base/profile_picture.dart](../views/base/profile_picture.dart)

```dart
// In ProfilePicture on edit button tap
File? pickedImage = await customImagePicker(
  isCircular: true,
  isSquared: false,
  ImageSource: ImageSource.gallery,
);

if (pickedImage != null) {
  widget.onImagePicked!(pickedImage);  // Return to parent
}
```

### **Function Signature**

```dart
Future<File?> customImagePicker({
  bool isCircular = true,                    // Circular crop
  bool isSquared = true,                     // Lock aspect ratio
  ImageSource source = ImageSource.gallery,  // gallery or camera
  int? imageQuality = 85,                    // Compression (1-100)
  bool enableCrop = true,                    // Show crop dialog
})
```

### **Usage Examples**

```dart
// Pick from gallery with circular crop
File? image = await customImagePicker(
  isCircular: true,
  source: ImageSource.gallery,
);

// Pick from camera with square crop
File? photo = await customImagePicker(
  isCircular: false,
  isSquared: true,
  source: ImageSource.camera,
);

// Pick and compress
File? optimized = await customImagePicker(
  imageQuality: 70,  // Lower quality = smaller file
  enableCrop: true,
);

// Use in ProfilePicture
onImagePicked: (file) async {
  File? cropped = await customImagePicker(
    isCircular: true,
    source: ImageSource.gallery,
  );
  if (cropped != null) {
    setState(() => selectedImage = cropped);
  }
}
```

---

## **Import All Widgets**

```dart
// Buttons & Inputs
import 'package:flutter_classic_mvc/views/base/custom_button.dart';
import 'package:flutter_classic_mvc/views/base/custom_text_field.dart';

// Images
import 'package:flutter_classic_mvc/views/base/custom_image.dart';
import 'package:flutter_classic_mvc/views/base/custom_image_picker.dart';

// Lists & Cards
import 'package:flutter_classic_mvc/views/base/app_list_view.dart';
import 'package:flutter_classic_mvc/views/base/product_card.dart';

// State Widgets
import 'package:flutter_classic_mvc/views/base/loading_widget.dart';
import 'package:flutter_classic_mvc/views/base/empty_widget.dart';
import 'package:flutter_classic_mvc/views/base/error_widget.dart';
import 'package:flutter_classic_mvc/views/base/no_internet_widget.dart';

// Special
import 'package:flutter_classic_mvc/views/base/profile_picture.dart';
```

---

## ✅ Widget Checklist

- [ ] **CustomButton** - Use for all actions
- [ ] **CustomTextField** - Use for all text inputs
- [ ] **CustomImage** - Use for all images (assets/network/files)
- [ ] **ProductCard** - Use in product lists
- [ ] **ProfilePicture** - Use for user avatars
- [ ] **AppListView** - Use for paginated lists
- [ ] **LoadingWidget** - Show during loading
- [ ] **EmptyWidget** - Show when no data
- [ ] **AppErrorWidget** - Show on errors
- [ ] **NoInternetWidget** - Show when offline
- [ ] **CustomImagePicker** - Use to select images

---

## 📚 Next Steps

- 👉 [**STATE_MANAGEMENT.md**](STATE_MANAGEMENT.md) - How to manage state
- 👉 [**ADD_FEATURES.md**](ADD_FEATURES.md) - Create new features
- 👉 [**CODE_EXAMPLES.md**](CODE_EXAMPLES.md) - More examples

---

**All widgets are tested and production-ready! Use them consistently across your app.** ✅
