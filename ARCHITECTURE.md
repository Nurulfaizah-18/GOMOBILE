# 🏗️ Clean Architecture Implementation Guide

## Penjelasan Lapisan Arsitektur

### 1. **Domain Layer** (Business Logic)
Lapisan paling dalam yang berisi logika bisnis aplikasi, independen dari teknologi.

#### Entities
- Objek core dari aplikasi
- Tidak bergantung pada framework eksternal
- Immutable dan equatable

```dart
// vehicle_entity.dart
class VehicleEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  // ... properties
}
```

#### Repositories (Abstract)
- Interface/kontrak untuk data operations
- Mendeskripsikan apa yang bisa dilakukan aplikasi

```dart
abstract class VehicleRepository {
  Future<Either<Exception, List<VehicleEntity>>> getAllVehicles();
  // ...
}
```

#### Use Cases
- Business logic untuk operasi spesifik
- Menerima parameter dan return hasil
- Dapat digunakan dalam tests

```dart
class GetAllVehiclesUsecase {
  final VehicleRepository repository;
  
  Future<Either<Exception, List<VehicleEntity>>> call() {
    return repository.getAllVehicles();
  }
}
```

### 2. **Data Layer** (Implementasi)
Lapisan untuk menangani data dari berbagai sumber.

#### Models
- Extension dari entities dengan serialization
- Digunakan untuk JSON mapping
- Contains mock data untuk development

```dart
class VehicleModel extends VehicleEntity {
  VehicleModel({...});
  
  factory VehicleModel.fromJson(Map<String, dynamic> json) => 
      _$VehicleModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
```

#### Data Sources
- **Remote**: API calls (Dio)
- **Local**: Local storage (SharedPreferences, Hive)

```dart
abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getAllVehicles();
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    // TODO: API call dengan Dio
    // Untuk sekarang menggunakan mock data
    return VehicleModel.getMockVehicles();
  }
}
```

#### Repositories (Implementation)
- Implementasi konkret dari abstract repository
- Menangani error dan data transformation
- Memilih data source yang tepat

```dart
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  
  @override
  Future<Either<Exception, List<VehicleEntity>>> getAllVehicles() async {
    try {
      final vehicles = await remoteDataSource.getAllVehicles();
      return Right(vehicles);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
```

### 3. **Presentation Layer** (UI & State Management)
Lapisan untuk user interface dan state management.

#### Providers (State Management)
- Menggunakan Riverpod untuk state management
- Decouple dari business logic

```dart
final vehiclesProvider = FutureProvider<List<VehicleEntity>>((ref) async {
  final usecase = ref.watch(getAllVehiclesUsecaseProvider);
  final result = await usecase();
  return result.fold(
    (exception) => throw exception,
    (vehicles) => vehicles,
  );
});
```

#### Pages/Screens
- Widget yang menampilkan UI
- Consume providers untuk data
- Handle user interactions

```dart
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    
    return vehiclesAsync.when(
      data: (vehicles) => GridView(...),
      loading: () => LoadingWidget(),
      error: (error, st) => ErrorWidget(),
    );
  }
}
```

#### Widgets
- Reusable UI components
- Custom widgets untuk fungsi spesifik

```dart
class VehicleCard extends StatelessWidget {
  // Custom widget untuk menampilkan vehicle item
}
```

### 4. **Core Layer** (Utilities)
Shared resources yang digunakan di semua lapisan.

```
core/
├── constants/      # App constants
├── theme/          # Colors, TextStyles, Theme
└── utils/          # Helper functions
```

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Pages (DashboardPage, CartPage, etc)                │  │
│  │  - Consume providers                                  │  │
│  │  - Display data                                       │  │
│  │  - Handle user interactions                           │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Providers (Riverpod)                                 │  │
│  │  - State management                                   │  │
│  │  - Call use cases                                     │  │
│  │  - Cache data                                         │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Widgets (Reusable Components)                        │  │
│  │  - VehicleCard, DateRangePickerWidget, etc           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Use Cases                                            │  │
│  │  - GetAllVehiclesUsecase                              │  │
│  │  - GetVehicleByIdUsecase                              │  │
│  │  - SearchVehiclesUsecase                              │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Repository (Abstract)                                │  │
│  │  - VehicleRepository interface                        │  │
│  │  - OrderRepository interface                          │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Entities                                             │  │
│  │  - VehicleEntity                                      │  │
│  │  - RentalOrderEntity                                  │  │
│  │  - CartItemEntity                                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Repository Implementation                            │  │
│  │  - VehicleRepositoryImpl                               │  │
│  │  - Handle errors                                      │  │
│  │  - Transform models to entities                       │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Data Sources                                         │  │
│  │  - VehicleRemoteDataSource (API)                      │  │
│  │  - VehicleLocalDataSource (Cache)                     │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Models                                               │  │
│  │  - VehicleModel (extends VehicleEntity)               │  │
│  │  - JSON serialization                                 │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────┐
│                 EXTERNAL API / DATABASE                      │
│  - REST API                                                  │
│  - Local Database                                            │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Use Case Flow Example

```dart
// User taps "Lihat Semua Kendaraan"
// ↓
// Pages call provider
final vehiclesAsync = ref.watch(vehiclesProvider);
// ↓
// Provider calls use case
final usecase = ref.watch(getAllVehiclesUsecaseProvider);
// ↓
// Use case calls repository
Future<Either<Exception, List<VehicleEntity>>> call() {
  return repository.getAllVehicles();
}
// ↓
// Repository calls data source
final vehicles = await remoteDataSource.getAllVehicles();
// ↓
// Data source returns mock/API data
return VehicleModel.getMockVehicles();
// ↓
// Repository transforms to entity
return Right(vehicles);
// ↓
// Use case returns to provider
// ↓
// Provider handles async state
data: (vehicles) => display list
loading: () => show spinner
error: (e) => show error message
```

## 🛡️ Error Handling

Menggunakan `Either<Exception, T>` dari `dartz` untuk functional error handling:

```dart
// Left = Error
// Right = Success

final result = await usecase.call();

result.fold(
  (exception) {
    // Handle error
    print('Error: $exception');
  },
  (data) {
    // Handle success
    print('Success: $data');
  },
);
```

## 🧪 Testing Strategy

### Unit Tests (Domain & Data)
```dart
test('GetAllVehiclesUsecase should return list of vehicles', () async {
  // Arrange
  when(mockRepository.getAllVehicles())
    .thenAnswer((_) async => Right(testVehicles));
  
  // Act
  final result = await usecase.call();
  
  // Assert
  expect(result, Right(testVehicles));
});
```

### Widget Tests (Presentation)
```dart
testWidgets('VehicleCard displays vehicle name', (tester) async {
  await tester.pumpWidget(TestApp(
    child: VehicleCard(
      name: 'Toyota Avanza',
      // ...
    ),
  ));
  
  expect(find.text('Toyota Avanza'), findsOneWidget);
});
```

## 🚀 Scaling & Improvements

### 1. Add API Integration
```dart
// Ganti mock data dengan Dio
import 'package:dio/dio.dart';

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio _dio;
  
  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    final response = await _dio.get('/vehicles');
    return (response.data as List)
      .map((v) => VehicleModel.fromJson(v))
      .toList();
  }
}
```

### 2. Add Local Caching
```dart
// Cache dengan SharedPreferences
class VehicleLocalDataSourceImpl implements VehicleLocalDataSource {
  final SharedPreferences prefs;
  
  Future<void> cacheVehicles(List<VehicleModel> vehicles) async {
    await prefs.setString(
      'vehicles',
      jsonEncode(vehicles.map((v) => v.toJson()).toList()),
    );
  }
}
```

### 3. Add Pagination
```dart
class GetPaginatedVehiclesUsecase {
  Future<Either<Exception, VehiclesPage>> call(int page, int limit) async {
    return repository.getPaginatedVehicles(page, limit);
  }
}
```

### 4. Add Firebase Integration
```dart
// Firebase untuk authentication dan realtime data
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final userProvider = FutureProvider((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser;
});
```

---

Dokumentasi ini memberikan pemahaman lengkap tentang bagaimana clean architecture diterapkan dalam project rental kendaraan ini. Setiap lapisan memiliki tanggung jawab spesifik dan independen dari lapisan lain, memudahkan testing, maintenance, dan scaling.
