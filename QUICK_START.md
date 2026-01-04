# Rental Kendaraan - Quick Start Guide

## 🚀 5-Minute Setup

### 1. Clone & Setup
```bash
cd d:\Gomobile\rental_kendaraan
flutter pub get
flutter pub run build_runner build
```

### 2. Run App
```bash
flutter run
```

✅ **Done!** Aplikasi akan berjalan dengan mock data.

---

## 📱 Navigation

| Tab | Page | Features |
|-----|------|----------|
| 🏠 | Dashboard | Popular vehicles, categories, all vehicles |
| 🔍 | Search | Real-time search by name/brand |
| 🛒 | Cart | Reservation list, checkout |
| 👤 | Profile | User info, settings, logout |

---

## 📁 Project Structure Quick Reference

```
lib/
├── core/          ← Colors, themes, constants, utils
├── data/          ← API calls, models, repositories
├── domain/        ← Business logic, entities, use cases
├── presentation/  ← Pages, providers (state), widgets
└── main.dart      ← Entry point
```

---

## 🎨 Theme Colors

- **Background**: `#0F1419` (Deep Grey)
- **Surface**: `#1A1F26` (Dark Surface)
- **Accent**: `#00D9FF` (Electric Blue)
- **Text**: `#F3F4F6` (Light Grey)

Use `AppColors` class: `AppColors.electricBlue`, `AppColors.darkBg`, etc.

---

## 🔧 Common Tasks

### Add New Page
```dart
// 1. Create file in lib/presentation/pages/
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(...);
  }
}

// 2. Add to navigation in main_page.dart
_pages.add(MyPage());

// 3. Add tab in GNav
GButton(icon: Icons.home_outlined, text: 'My Page')
```

### Add New Provider
```dart
// lib/presentation/providers/my_provider.dart
final myProvider = FutureProvider<MyEntity>((ref) async {
  final usecase = ref.watch(myUsecaseProvider);
  final result = await usecase();
  return result.fold((e) => throw e, (data) => data);
});

// Use in widget
final dataAsync = ref.watch(myProvider);
dataAsync.when(
  data: (data) => Text(data.toString()),
  loading: () => LoadingWidget(),
  error: (e, st) => ErrorWidget(),
);
```

### Add New API Endpoint
```dart
// 1. Create model in lib/data/models/
class MyModel extends MyEntity {
  factory MyModel.fromJson(Map<String, dynamic> json) => ...
}

// 2. Create datasource in lib/data/datasources/remote/
class MyRemoteDataSource {
  Future<MyModel> getData() async {
    // API call with Dio
    return remoteDataSource.getData();
  }
}

// 3. Create repository in lib/data/repositories/
class MyRepositoryImpl implements MyRepository {
  Future<Either<Exception, MyEntity>> getData() async {
    try {
      final data = await remoteDataSource.getData();
      return Right(data);
    } catch (e) {
      return Left(e);
    }
  }
}
```

### Use State Management (Provider)
```dart
// Read state
final data = ref.read(myProvider);

// Watch state (rebuild when changes)
final dataAsync = ref.watch(myProvider);

// Modify state
ref.read(cartProvider.notifier).addToCart(vehicle, startDate, endDate);

// Refresh provider
ref.refresh(myProvider);
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/domain/usecases/vehicle_usecases_test.dart

# With coverage
flutter test --coverage
```

---

## 📋 File Templates

### New Entity
```dart
import 'package:equatable/equatable.dart';

class MyEntity extends Equatable {
  final String id;
  final String name;

  const MyEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
```

### New Model
```dart
import 'package:json_annotation/json_annotation.dart';
import 'my_entity.dart';

part 'my_model.g.dart';

@JsonSerializable()
class MyModel extends MyEntity {
  const MyModel({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);
}
```

### New Use Case
```dart
import 'package:dartz/dartz.dart';
import '../entities/my_entity.dart';
import '../repositories/my_repository.dart';

class GetMyDataUsecase {
  final MyRepository repository;

  GetMyDataUsecase(this.repository);

  Future<Either<Exception, MyEntity>> call() {
    return repository.getMyData();
  }
}
```

---

## 🐛 Debugging

### View Logs
```bash
flutter logs
```

### Run with Verbose
```bash
flutter run -v
```

### Hot Reload
- Press `r` in terminal (while running)

### Hot Restart
- Press `R` in terminal (while running)

### Check Device
```bash
flutter devices
```

---

## 📚 Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/core/theme/app_colors.dart` | Color palette |
| `lib/core/theme/app_theme.dart` | ThemeData configuration |
| `lib/data/models/vehicle_model.dart` | Vehicle data model |
| `lib/domain/entities/vehicle_entity.dart` | Vehicle business entity |
| `lib/presentation/pages/main_page.dart` | Main navigation |
| `lib/presentation/providers/vehicle_provider.dart` | Vehicle state management |

---

## 🌐 Environments

### Development
```dart
// Mock data used
const bool isDevelopment = true;
```

### Production
```dart
// Real API calls
const bool isDevelopment = false;
```

---

## 📦 Package Quick Links

- [flutter_riverpod](https://riverpod.dev) - State management
- [google_nav_bar](https://pub.dev/packages/google_nav_bar) - Navigation
- [intl](https://pub.dev/packages/intl) - Localization
- [dio](https://pub.dev/packages/dio) - HTTP client
- [json_annotation](https://pub.dev/packages/json_annotation) - JSON serialization

---

## ✅ Before Push to Production

- [ ] Replace mock data dengan real API
- [ ] Setup Firebase authentication
- [ ] Configure payment gateway
- [ ] Add proper error handling
- [ ] Implement offline support
- [ ] Add unit & widget tests
- [ ] Performance optimization
- [ ] Update icons & splash screen
- [ ] Configure signing (Android/iOS)
- [ ] Test on physical devices

---

## 🎓 Learning Path

1. **Understand Architecture** → Read `ARCHITECTURE.md`
2. **Setup Project** → Follow `SETUP.md`
3. **Explore Features** → Check `FEATURES.md`
4. **Learn Implementation** → See `examples_implementation.dart`
5. **Full Documentation** → Read `DOCUMENTATION.md`

---

## 🔗 Useful Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Documentation](https://riverpod.dev)
- [Clean Architecture Article](https://resocoder.com/flutter-clean-architecture)
- [Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

---

## 💬 Common Questions

**Q: Bagaimana cara menambah halaman baru?**
A: Buat file di `lib/presentation/pages/`, import di `main_page.dart`, dan tambahkan ke navigation.

**Q: Bagaimana cara mengubah warna?**
A: Edit `lib/core/theme/app_colors.dart` dan gunakan `AppColors.xxx` di mana saja.

**Q: Bagaimana cara setup Firebase?**
A: Lihat `FEATURES.md` section Firebase Integration.

**Q: Bagaimana cara menjalankan tests?**
A: Gunakan command `flutter test` atau `flutter test <file_path>`.

**Q: Bagaimana cara build APK?**
A: Gunakan command `flutter build apk --release`.

---

## 🚨 Troubleshooting Quick Fixes

```bash
# Pub get error
flutter clean && flutter pub get

# Build error
flutter clean && flutter pub get && flutter pub run build_runner clean && flutter pub run build_runner build

# Device not found
flutter devices

# Port in use
flutter run -d <device_id>

# Generated files not updating
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

**Happy Coding! 🎉**

Untuk bantuan lebih lanjut, lihat dokumentasi lengkap di `DOCUMENTATION.md` atau `ARCHITECTURE.md`.

