# 🚀 Setup & Installation Guide

## Prerequisites

Pastikan Anda memiliki:
- Flutter SDK 3.0 atau lebih tinggi
- Dart SDK 3.0 atau lebih tinggi
- Android Studio / VS Code dengan Flutter extension
- XCode (untuk iOS development)
- Git

## 1️⃣ Installation Steps

### Step 1: Clone Repository
```bash
cd d:\Gomobile
git clone <repository_url>
cd rental_kendaraan
```

### Step 2: Get Flutter SDK
Jika belum install, download dari https://flutter.dev

### Step 3: Install Dependencies
```bash
flutter pub get
```

### Step 4: Generate Model Files
```bash
flutter pub run build_runner build
```

Atau jika ingin watch mode:
```bash
flutter pub run build_runner watch
```

### Step 5: Run Application
```bash
flutter run
```

## 📱 Running on Different Platforms

### Android
```bash
flutter run -d android
# atau untuk device spesifik
flutter run -d emulator-5554
```

### iOS
```bash
cd ios
pod install
cd ..
flutter run -d ios
```

### Web (jika enable)
```bash
flutter run -d chrome
```

## 🔧 Build for Production

### Android APK
```bash
flutter build apk
# Hasil: build/app/outputs/apk/release/app-release.apk
```

### Android App Bundle
```bash
flutter build appbundle
# Hasil: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
```

## 📝 Project Configuration

### Update pubspec.yaml
Jika dependencies perlu diupdate:
```yaml
flutter pub upgrade
```

### Update specific package
```bash
flutter pub upgrade package_name
```

## ✅ Verify Installation

```bash
# Check Flutter version
flutter --version

# Check all dependencies
flutter pub outdated

# Check for any issues
flutter doctor
```

## 🐛 Troubleshooting

### Issue: "No devices connected"
```bash
# List available devices
flutter devices

# Emulator belum running
emulator -list-avds
emulator -avd <emulator_name>
```

### Issue: Build error pada pub get
```bash
# Clean cache
flutter clean
pub cache repair

# Get dependencies lagi
flutter pub get
```

### Issue: Android build error
```bash
# Update gradle
cd android
./gradlew --version

# Build Android
flutter build apk --verbose
```

### Issue: Generated files tidak update
```bash
# Clear generated files
find . -name "*.g.dart" -delete
find . -name "*.config.dart" -delete

# Rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📦 Package Management

### Add New Package
```bash
flutter pub add package_name
```

### Remove Package
```bash
flutter pub remove package_name
```

### Add Dev Dependency
```bash
flutter pub add --dev package_name
```

## 🧪 Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test
```bash
flutter test test/domain/usecases/vehicle_usecases_test.dart
```

### Run with coverage
```bash
flutter test --coverage
```

## 🔗 Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-feature

# Commit changes
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/new-feature

# Create pull request di GitHub
```

## 🛠️ Development Setup Checklist

- [ ] Flutter SDK installed & updated
- [ ] IDE setup (VS Code extensions / Android Studio plugins)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Model files generated (`flutter pub run build_runner build`)
- [ ] Application runs successfully (`flutter run`)
- [ ] Emulator/Device connected
- [ ] Git repository configured

## 📚 Useful Commands

```bash
# Hot reload (development)
r - Hot reload
R - Hot restart

# Device/Emulator
flutter devices

# Logs
flutter logs

# Analyze code
flutter analyze

# Format code
flutter format .

# Get pubspec.lock
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Clean build artifacts
flutter clean
```

## 🚨 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Gradle error | Run `flutter clean` then `flutter pub get` |
| Pod install error (iOS) | Run `cd ios && pod install --repo-update && cd ..` |
| Generated files error | Delete `.g.dart` files and run build_runner again |
| Port already in use | Change port: `flutter run --device-id=<id>` |
| Memory error | Increase heap: `export GRADLE_OPTS="-Xmx4096m"` |

## 📞 Support

Jika mengalami masalah:
1. Check Flutter docs: https://flutter.dev/docs
2. Check package documentation
3. Search Stack Overflow
4. Report issue di GitHub

---

Happy coding! 🎉
