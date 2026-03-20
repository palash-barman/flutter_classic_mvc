# 📦 BUILD & DEPLOYMENT - Release Builds

How to build for production and release.

---

## **Android Build**

### **Generate Signing Key (One Time)**

```bash
# Generate keystore file
keytool -genkey -v \
  -keystore ~/my-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias my-key-alias

# Prompts for:
# - Password (remember this!)
# - First/Last Name
# - Organizational Unit
# - Organization
# - City
# - State
# - Country Code (US = 2 letters)
```

### **Configure gradle**

```gradle
// android/app/build.gradle.kts
android {
    signingConfigs {
        release {
            keyAlias = "my-key-alias"
            keyPassword = "YOUR_KEY_PASSWORD"
            storeFile = file("/path/to/my-release-key.jks")
            storePassword = "YOUR_STORE_PASSWORD"
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.release
        }
    }
}
```

### **Build APK**

```bash
# Build APK (installable on phone)
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
# Size: ~40-100 MB

# Install on device
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### **Build App Bundle (For Play Store)**

```bash
# Build App Bundle (smaller download, optimized)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
# Size: ~15-30 MB

# More efficient for Google Play Store
```

### **Test Signed APK**

```bash
# Verify APK is signed
jarsigner -verify -verbose \
  build/app/outputs/flutter-apk/app-release.apk
```

---

## **iOS Build**

### **Setup for Release**

```bash
# Open iOS project
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select Runner in projects
# 2. Go to Signing & Capabilities
# 3. Select development team
# 4. Update Bundle ID (if needed)
```

### **Build Archive**

```bash
# Build for release
flutter build ios --release

# Or in Xcode
# Product → Scheme → Edit Scheme
# Set to Release mode
# Product → Archive
```

### **Distribute to App Store**

```bash
# In Xcode:
# 1. Select "Any iOS Device (arm64)"
# 2. Product → Archive
# 3. Distribute App
# 4. Follow prompts
# 5. Submit for review
```

---

## **Web Build (Optional)**

```bash
# Build for web
flutter build web --release

# Output: build/web/
# Deploy to web server (Firebase, Netlify, etc)
```

---

## **Version Management**

### **Update Version**

```yaml
# pubspec.yaml
version: 1.0.0+1
# Format: 1.0.0 (version) + 1 (build number)

# Update for releases
# 1.0.0+1 (initial)
# 1.0.1+2 (patch - bug fix)
# 1.1.0+3 (minor - new feature)
# 2.0.0+4 (major - breaking change)
```

### **Update Android/iOS Version**

```gradle
// android/app/build.gradle.kts
android {
    defaultConfig {
        versionCode = 1      // Increment for each release
        versionName = "1.0.0"
    }
}
```

```swift
// ios/Runner/Info.plist
<dict>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>  <!-- Update this -->
    <key>CFBundleVersion</key>
    <string>1</string>      <!-- Update this -->
</dict>
```

---

## **Pre-Release Checklist**

```bash
# 1. Code analysis
flutter analyze --no-pub

# 2. Format code
dart format .

# 3. Run tests
flutter test

# 4. Build for both platforms
flutter build apk --release
flutter build ios --release

# 5. Update version
# Edit pubspec.yaml, build.gradle, Info.plist

# 6. Create git tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# 7. Update changelog
# Add notes to CHANGELOG.md

# 8. Sign & notarize (macOS)
# If building for macOS
```

---

## **Google Play Store Submission**

### **Step 1: Create Signed App**

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### **Step 2: Upload to Play Store**

1. Go to [Google Play Console](https://play.google.com/console)
2. Create app or select existing
3. Go to Release → Production
4. Create release
5. Upload `app-release.aab`
6. Fill metadata (description, screenshots, etc)
7. Review and submit

### **Step 3: Wait for Review**

- Initial review: 2-4 hours
- Full review: 24+ hours
- Minor updates: Faster

---

## **App Store Submission (iOS)**

### **Step 1: Create App**

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app
3. Fill metadata

### **Step 2: Review Guidelines**

Check [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

### **Step 3: Submit for Review**

1. In Xcode, Archive app
2. Distribute App → Upload
3. Follow prompts
4. Submit for review

### **Step 4: Wait for Review**

- Initial review: 24-48 hours
- Standard review: 24+ hours
- Expedited: Still 24+ hours

---

## **Environment-Specific Builds**

### **Build for Different Environments**

```bash
# Development
flutter build apk --release \
  --dart-define=FLAVOR=dev

# Staging
flutter build apk --release \
  --dart-define=FLAVOR=staging

# Production
flutter build apk --release \
  --dart-define=FLAVOR=prod
```

### **Use in Code**

```dart
// lib/main.dart
import 'package:flutter_gen/environment.dart';

void main() {
  // Get flavor from environment
  String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  
  switch (flavor) {
    case 'dev':
      EnvironmentConfig.init(Environment.dev);
      break;
    case 'staging':
      EnvironmentConfig.init(Environment.staging);
      break;
    case 'prod':
      EnvironmentConfig.init(Environment.prod);
      break;
  }
  
  runApp(MyApp());
}
```

---

## **CI/CD Pipeline Example**

### **GitHub Actions**

```yaml
# .github/workflows/release.yml
name: Release Build

on:
  push:
    tags:
      - 'v*'

jobs:
  android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v1
        with:
          java-version: '11'
      - uses: subosito/flutter-action@v1
        with:
          flutter-version: '3.10.0'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v2
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## **Performance Optimization**

### **Reduce APK Size**

```bash
# Build with size analysis
flutter build apk --release --analyze-size

# Strip symbols
flutter build apk --release --split-per-abi

# Output: Multiple APKs (one per architecture)
```

### **Enable Proguard (Android)**

```gradle
// android/app/build.gradle.kts
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles(
                getDefaultProguardFile('proguard-android.txt'),
                'proguard-rules.pro'
            )
        }
    }
}
```

---

## **Publish Checklist**

- [ ] Code compiles without errors
- [ ] flutter analyze passes (0 issues)
- [ ] flutter test passes
- [ ] Version bumped in pubspec.yaml
- [ ] Android version updated
- [ ] iOS version updated
- [ ] Screenshots prepared (800x600px)
- [ ] Description written
- [ ] Privacy policy added
- [ ] App icons set correctly
- [ ] Permissions documented
- [ ] Release notes written
- [ ] Signed APK/bundle created
- [ ] Tested on real device
- [ ] No console warnings/errors
- [ ] git tagged with version

---

## **Monitoring After Release**

```bash
# Monitor crashes
# Firebase Crashlytics / Sentry

# Monitor performance
# Firebase Performance Monitoring

# User feedback
# App Store reviews
# Google Play reviews
```

---

## **Rollback Procedure**

If critical bug found:

```bash
# 1. Hotfix code
git checkout v1.0.0
git checkout -b hotfix/critical-bug

# 2. Fix bug
# ... make changes ...

# 3. Increment build number
# Update version to 1.0.1

# 4. Rebuild and republish
flutter build appbundle --release

# 5. Submit new version
```

---

## ✅ Release Checklist

- [ ] Version updated
- [ ] Code analyzed
- [ ] Tests passing
- [ ] Built successfully
- [ ] Screenshots prepared
- [ ] Metadata filled
- [ ] Privacy policy added
- [ ] Tested on device
- [ ] Git tagged
- [ ] Submitted

---

## 📚 Useful Links

- [Flutter Build Documentation](https://flutter.dev/docs/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Firebase Deployment](https://firebase.google.com/products/app-distribution)

---

## 📚 Next Steps

- 👉 [**TESTING.md**](TESTING.md) - Write tests
- 👉 [**BEST_PRACTICES.md**](BEST_PRACTICES.md) - Follow standards
- 👉 [**TROUBLESHOOTING.md**](TROUBLESHOOTING.md) - Fix issues

---

**Always test before releasing to production!**
