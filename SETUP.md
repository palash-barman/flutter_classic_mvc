# 🚀 SETUP & INSTALLATION GUIDE

Complete setup instructions for **Classic MVC Flutter Project** for new developers.

---

## 📋 Prerequisites

### **Required**
- Flutter SDK 3.10.1+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK 3.10.1+ (comes with Flutter)
- Git ([Install Git](https://git-scm.com))
- VS Code or Android Studio / Xcode

### **Recommended**
- VS Code Extensions:
  - Flutter
  - Dart
  - GetX
  - awesome-flutter-snippets

### **System Requirements**
- Minimum 4GB RAM (8GB recommended)
- 500MB free disk space
- Latest IDE and tools

---

## 🔧 Installation Steps

### **Step 1: Clone Repository**
```bash
git clone https://github.com/your-org/flutter_classic_mvc.git
cd flutter_classic_mvc
```

### **Step 2: Get Flutter Dependencies**
```bash
flutter clean
flutter pub get
```

### **Step 3: Generate Code (if using build_runner)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### **Step 4: Run on Device/Emulator**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Or simply run (will use default device)
flutter run
```

---

## 🔐 Environment Configuration

### **Create `.env` file** (if using flutter_dotenv)
```
# .env
API_BASE_URL=https://api.example.com
API_TIMEOUT=30
DEBUG_MODE=true
```

### **Environment Setup**
Create separate environment files:
- `.env.dev` - Development  
- `.env.staging` - Staging  
- `.env.prod` - Production

### **Configure in Code**
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
      // ... other environments
    }
  }
}
```

---

## 📱 Running the App

### **On Android**
```bash
# List available Android devices
flutter emulators

# Launch Android emulator
flutter emulators --launch emulator-name

# Run on emulator
flutter run
```

### **On iOS**
```bash
# Must run on macOS/Linux with Xcode
cd ios
pod install
cd ..
flutter run
```

### **On Web** (experimental)
```bash
# Enable web
flutter config --enable-web

# Run on web
flutter run -d web-server

# Build web app
flutter build web
```

---

## 🧪 Testing Setup

### **Unit Tests**
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/controllers/login_controller_test.dart

# Run with coverage
flutter test --coverage
```

### **Widget Tests**
```bash
flutter test test/views/login_page_test.dart
```

### **Integration Tests**
```bash
flutter test integration_test/
```

---

## 🔍 Code Quality

### **Static Analysis**
```bash
# Analyze code
flutter analyze

# With strict rules
flutter analyze --fatal-infos
```

### **Format Code**
```bash
# Format all files
dart format .

# Format specific file
dart format lib/main.dart
```

### **Check Dependencies**
```bash
# Check for outdated packages
flutter pub outdated

# Check for conflicts
flutter pub upgrade
```

---

## 🐛 Debugging

### **Debug Mode**
```bash
flutter run -v  # Verbose output
```

### **Hot Reload**
```
Press 'r' in terminal to reload
Press 'R' to restart
Press 'q' to quit
```

### **Dart DevTools**
```bash
# Open DevTools
flutter pub global activate devtools
devtools

# Or use with running app
flutter run --observe=<port>
```

---

## 📦 Build & Release

### **Debug Build**
```bash
flutter build apk --debug
```

### **Release Build (Android)**
```bash
flutter build apk --release
flutter build appbundle --release
```

### **Release Build (iOS)**
```bash
flutter build ios --release
```

### **Web Build**
```bash
flutter build web --release
```

---

## 🔑 API Integration

### **API Base URL**
Update in `lib/core/config/environment.dart`:
```dart
static const String baseUrl = 'https://your-api.com';
```

### **Add API Endpoints**
```dart
// lib/services/api_endpoints.dart
class ApiEndpoints {
  static const String newEndpoint = '/your-endpoint';
}
```

### **Use in Controller**
```dart
final data = await ApiService().get(ApiEndpoints.newEndpoint);
```

---

## 📚 Database Setup (Optional)

### **Using SQLite**
```bash
flutter pub add sqflite
```

### **Using Hive**
```bash
flutter pub add hive hive_flutter
```

### **Using Firebase**
```bash
flutter pub add firebase_core firebase_database
```

---

## 🔐 Security Checklist

- [ ] Never commit `.env` files with secrets
- [ ] Use `.gitignore` to exclude sensitive files
- [ ] Use HTTPS for all API calls
- [ ] Validate all user inputs
- [ ] Store tokens securely
- [ ] Implement SSL pinning for critical endpoints
- [ ] Obfuscate code in release builds

### **Sample `.gitignore` additions**
```
.env
.env.*
!.env.example
```

---

## 🚀 Deployment

### **To Google Play Store (Android)**
1. Create signing keystore
2. Update build.gradle
3. Run: `flutter build appbundle --release`
4. Upload AAB to Google Play Console

### **To Apple App Store (iOS)**
1. Create provisioning profiles in Apple Developer
2. Update build settings
3. Run: `flutter build ios --release`
4. Upload to App Store Connect

### **To Firebase Hosting (Web)**
```bash
flutter build web --release
firebase deploy
```

---

## 🆘 Troubleshooting

### **"Command 'flutter' not found"**
- Add Flutter to PATH: `export PATH="$PATH:`pwd`/flutter/bin"`

### **"Pod install failed"** (iOS)
```bash
cd ios
rm -rf Pods
rm -rf .symlinks/
rm -rf Flutter/Flutter.framework
cd ..
flutter clean
flutter pub get
```

### **"Gradle build failed"** (Android)
```bash
flutter clean
rm -rf android/.gradle
flutter pub get
flutter run
```

### **"Out of Memory"**
- Increase heap: `export GRADLE_HEAP_SIZE=2048m`
- Close other applications
- Restart IDE

### **"Dart SDK path not found"**
- Ensure Flutter SDK is properly installed
- Run: `flutter doctor` to verify setup

---

## ✅ Verification Checklist

After setup, verify:
- [ ] `flutter doctor` shows all green ✓
- [ ] `flutter analyze` shows no issues
- [ ] App runs on emulator/device
- [ ] API calls work correctly
- [ ] UI renders properly
- [ ] Navigation works
- [ ] No console errors

---

## 📞 Getting Help

- Check [Flutter Documentation](https://flutter.dev/docs)
- Review [Dart Documentation](https://dart.dev/guides)
- Check [GetX Documentation](https://github.com/jonataslaw/getx)
- Ask in team Slack/Discord channel

---

## 📝 Notes

- Always run `flutter pub get` after pulling new changes
- Clear cache if experiencing strange behavior: `flutter clean`
- Update Flutter regularly: `flutter upgrade`
- Keep dependencies up to date: `flutter pub upgrade`

---

**Happy Development! 🎉**
