# 📚 Dokumentasi Lengkap - Rental Kendaraan App

## 📖 Table of Contents

1. [Overview](#overview)
2. [Struktur Project](#struktur-project)
3. [Teknologi & Dependencies](#teknologi--dependencies)
4. [Fitur-Fitur](#fitur-fitur)
5. [Instalasi & Setup](#instalasi--setup)
6. [Panduan Pengembangan](#panduan-pengembangan)
7. [API Reference](#api-reference)
8. [Troubleshooting](#troubleshooting)

---

## Overview

**Rental Kendaraan** adalah aplikasi Flutter modern untuk menyewa kendaraan (mobil dan motor) dengan arsitektur clean yang memisahkan concerns dan memudahkan testing serta maintenance.

### Key Features
- ✨ Modern Dark Mode UI dengan Electric Blue accent
- 🏗️ Clean Architecture dengan 3 layers (Domain, Data, Presentation)
- 📱 Responsive design untuk semua ukuran layar
- 🛒 Cart & Reservation System
- 📅 Date Range Picker untuk flexible rental dates
- 🔍 Search & Filter functionality
- 👤 User Profile Management
- 💳 Mock Payment System

### Technologies
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Riverpod 2.4+
- **Navigation**: Google Nav Bar
- **Architecture**: Clean Architecture + MVVM

---

## Struktur Project

```
rental_kendaraan/
│
├── lib/
│   ├── core/                          # Shared resources
│   │   ├── constants/
│   │   │   └── app_constants.dart    # Constants
│   │   ├── theme/
│   │   │   ├── app_colors.dart       # Color palette
│   │   │   └── app_theme.dart        # ThemeData
│   │   ├── utils/
│   │   │   └── date_formatter.dart   # Utility functions
│   │   └── config/
│   │       └── state_management_config.dart
│   │
│   ├── data/                          # Data Layer
│   │   ├── datasources/
│   │   │   ├── local/
│   │   │   │   └── vehicle_local_datasource.dart
│   │   │   └── remote/
│   │   │       └── vehicle_remote_datasource.dart
│   │   ├── models/
│   │   │   ├── vehicle_model.dart
│   │   │   └── vehicle_model.g.dart  # Generated
│   │   └── repositories/
│   │       ├── vehicle_repository_impl.dart
│   │       └── order_repository_impl.dart
│   │
│   ├── domain/                        # Domain Layer (Business Logic)
│   │   ├── entities/
│   │   │   ├── vehicle_entity.dart
│   │   │   ├── rental_order_entity.dart
│   │   │   └── cart_item_entity.dart
│   │   ├── repositories/
│   │   │   ├── vehicle_repository.dart
│   │   │   └── order_repository.dart
│   │   └── usecases/
│   │       ├── vehicle_usecases.dart
│   │       └── order_usecases.dart
│   │
│   ├── presentation/                  # Presentation Layer (UI)
│   │   ├── pages/
│   │   │   ├── main_page.dart
│   │   │   ├── dashboard_page.dart
│   │   │   ├── vehicle_detail_page.dart
│   │   │   ├── search_page.dart
│   │   │   ├── cart_page.dart
│   │   │   └── profile_page.dart
│   │   ├── providers/
│   │   │   ├── vehicle_provider.dart
│   │   │   ├── cart_provider.dart
│   │   │   └── date_range_provider.dart
│   │   └── widgets/
│   │       ├── vehicle_card.dart
│   │       ├── date_range_picker_widget.dart
│   │       ├── specification_item.dart
│   │       └── category_chip.dart
│   │
│   ├── main.dart                      # Entry point
│   └── exports.dart                   # Barrel file
│
├── test/                              # Tests
│
├── assets/                            # Assets
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── pubspec.yaml                       # Dependencies
├── README.md
├── ARCHITECTURE.md                    # Architecture guide
├── FEATURES.md                        # Features guide
└── SETUP.md                           # Setup guide
```

---

## Teknologi & Dependencies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | 3.0+ | UI Framework |
| flutter_riverpod | 2.4+ | State Management |
| google_nav_bar | 5.0.5 | Navigation Bar |
| intl | 0.19.0 | Internationalization |
| json_annotation | 4.8.0 | Serialization |
| equatable | 2.0.5 | Value Equality |
| dartz | 0.10.1 | Functional Programming |
| dio | 5.3.0 | HTTP Client |

### Development Dependencies

| Package | Purpose |
|---------|---------|
| build_runner | Code generation |
| json_serializable | Auto JSON serialization |
| flutter_test | Testing framework |

---

## Fitur-Fitur

### 1. Dashboard
```dart
// Menampilkan:
- Kendaraan terpopuler dalam horizontal scroll
- Kategori kendaraan (Chip buttons)
- Grid semua kendaraan dengan filtering
- Pull-to-refresh

// File: lib/presentation/pages/dashboard_page.dart
```

### 2. Vehicle Detail
```dart
// Menampilkan:
- Full-screen vehicle image
- Spesifikasi (kursi, transmisi, bahan bakar, tahun)
- Deskripsi lengkap
- Date Range Picker (pemilihan tanggal)
- Price calculation
- Add to cart button

// File: lib/presentation/pages/vehicle_detail_page.dart
```

### 3. Search
```dart
// Features:
- Real-time search by name/brand
- Grid display
- Empty state handling
- Auto-complete ready

// File: lib/presentation/pages/search_page.dart
```

### 4. Cart/Reservation
```dart
// Features:
- List cart items dengan preview
- Delete individual items
- Clear all cart
- Total price calculation
- Checkout button (mockup)

// File: lib/presentation/pages/cart_page.dart
```

### 5. Profile
```dart
// Features:
- User info display
- Menu navigation
- Settings
- Logout

// File: lib/presentation/pages/profile_page.dart
```

### 6. Navigation
```dart
// Using google_nav_bar:
- 4 main tabs
- Smooth transitions
- Modern design

// File: lib/presentation/pages/main_page.dart
```

---

## Instalasi & Setup

### Prerequisites
```bash
flutter --version  # >= 3.0.0
dart --version     # >= 3.0.0
```

### Step-by-step Installation

1. **Navigate to project**
```bash
cd d:/Gomobile/rental_kendaraan
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Generate model files**
```bash
flutter pub run build_runner build
```

4. **Run application**
```bash
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## Panduan Pengembangan

### Adding New Feature

1. **Create Domain Layer** (Business Logic)
```dart
// lib/domain/entities/new_entity.dart
class NewEntity extends Equatable {
  final String id;
  // properties...
  const NewEntity({required this.id});
  @override
  List<Object?> get props => [id];
}

// lib/domain/repositories/new_repository.dart
abstract class NewRepository {
  Future<Either<Exception, NewEntity>> getNew();
}

// lib/domain/usecases/new_usecase.dart
class GetNewUsecase {
  final NewRepository repository;
  Future<Either<Exception, NewEntity>> call() => repository.getNew();
}
```

2. **Create Data Layer** (Implementation)
```dart
// lib/data/models/new_model.dart
class NewModel extends NewEntity {
  factory NewModel.fromJson(Map<String, dynamic> json) => ...
  Map<String, dynamic> toJson() => ...
}

// lib/data/repositories/new_repository_impl.dart
class NewRepositoryImpl implements NewRepository {
  @override
  Future<Either<Exception, NewEntity>> getNew() async {
    try {
      final data = await remoteDataSource.getNew();
      return Right(data);
    } catch (e) {
      return Left(e);
    }
  }
}
```

3. **Create Presentation Layer** (UI)
```dart
// lib/presentation/providers/new_provider.dart
final newProvider = FutureProvider<NewEntity>((ref) async {
  final usecase = ref.watch(getNewUsecaseProvider);
  final result = await usecase();
  return result.fold((e) => throw e, (data) => data);
});

// lib/presentation/pages/new_page.dart
class NewPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newAsync = ref.watch(newProvider);
    return newAsync.when(
      data: (data) => Text(data.toString()),
      loading: () => CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/domain/usecases/vehicle_usecases_test.dart

# With coverage
flutter test --coverage
```

### Code Generation

```bash
# Generate JSON serialization
flutter pub run build_runner build

# Watch mode (auto-regenerate)
flutter pub run build_runner watch

# Clean generated files
flutter pub run build_runner clean
```

---

## API Reference

### Vehicle Provider

```dart
// Get all vehicles
final vehiclesProvider = StateNotifierProvider<VehiclesNotifier, 
  AsyncValue<List<VehicleEntity>>>

// Get popular vehicles
final popularVehiclesProvider = FutureProvider<List<VehicleEntity>>

// Get vehicle by ID
final vehicleDetailProvider = FutureProvider.family<VehicleEntity, String>

// Search vehicles
final searchResultsProvider = FutureProvider<List<VehicleEntity>>

// Selected category
final selectedCategoryProvider = StateProvider<VehicleCategory>
```

### Cart Provider

```dart
// Cart items
final cartProvider = StateNotifierProvider<CartNotifier, 
  List<CartItemEntity>>

// Total price
final cartTotalPriceProvider = Provider<double>

// Item count
final cartCountProvider = Provider<int>

// Methods:
// addToCart(vehicle, startDate, endDate)
// removeFromCart(itemId)
// clearCart()
// getTotalPrice()
// getCartCount()
```

### Date Range Provider

```dart
// Date range
final dateRangeProvider = StateNotifierProvider<DateRangeNotifier, 
  DateRange>

// Rental days
final rentalDaysProvider = Provider<int>

// Methods:
// setDateRange(startDate, endDate)
// setStartDate(date)
// setEndDate(date)
// getDays()
```

### Models & Entities

```dart
// VehicleEntity
class VehicleEntity {
  final String id;
  final String name;
  final String brand;
  final VehicleCategory category;
  final FuelType fuelType;
  final TransmissionType transmission;
  final int seats;
  final String imageUrl;
  final double pricePerDay;
  final String licensePlate;
  final int year;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String description;
}

// CartItemEntity
class CartItemEntity {
  final String id;
  final VehicleEntity vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDays;
  final double totalPrice;
}

// RentalOrderEntity
class RentalOrderEntity {
  final String id;
  final VehicleEntity vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDays;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
}
```

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `Error: Could not find plugin` | Run `flutter pub get` |
| `Generated files not updating` | Run `flutter pub run build_runner clean` then rebuild |
| `Null safety error` | Update Flutter SDK to latest |
| `Port already in use` | `flutter run -d <device_id>` dengan device berbeda |
| `Gradle build error` | Run `flutter clean` then `flutter pub get` |
| `iOS Pod error` | `cd ios && pod install --repo-update && cd ..` |

### Debug Mode

```bash
# Run with verbose logging
flutter run -v

# Run with observatory URL
flutter run --observatory-port=0

# Check device logs
flutter logs

# Attach to running app
flutter attach
```

### Performance Tips

1. **Use const constructors**
```dart
const VehicleCard(...) // Good
VehicleCard(...) // Bad
```

2. **Cache images**
```dart
Image.network(
  url,
  cacheHeight: 300,
  cacheWidth: 300,
)
```

3. **Use ListView.builder instead of ListView**
```dart
ListView.builder(...)  // Good
ListView(children: [...])  // Bad
```

4. **Profile your app**
```bash
flutter run --profile
```

---

## 📞 Support & Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev
- **Dart Docs**: https://dart.dev/guides
- **Stack Overflow**: Tag dengan `flutter`
- **GitHub Issues**: Report bugs dengan details

---

## License

Proyek ini adalah untuk kebutuhan pendidikan dan pengembangan.

---

**Last Updated**: Desember 2025
**Author**: Development Team
**Version**: 1.0.0

