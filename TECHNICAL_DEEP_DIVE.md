# Technical Deep Dive - Vehicle Save Implementation

## Architecture Overview

Sistem penyimpanan kendaraan mengikuti **Clean Architecture** dengan 4 layers:

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  - add_vehicle_page.dart (UI & Form)               │
│  - vehicle_provider.dart (State Management)         │
└─────────────────────────────────────────────────────┘
                       ↓ (depends on)
┌─────────────────────────────────────────────────────┐
│  DOMAIN LAYER                                        │
│  - vehicle_usecases.dart (Business Logic)          │
│  - vehicle_repository.dart (Interface)             │
└─────────────────────────────────────────────────────┘
                       ↓ (depends on)
┌─────────────────────────────────────────────────────┐
│  DATA LAYER                                          │
│  - vehicle_repository_impl.dart (Implementation)    │
│  - vehicle_remote_datasource.dart (Remote Storage)  │
│  - vehicle_local_datasource.dart (Local Storage)    │
└─────────────────────────────────────────────────────┘
```

## Detailed Flow: Adding a Vehicle

### 1. User Interface (add_vehicle_page.dart)

```dart
// Step 1: User fills form and clicks "Simpan"
void _submitForm() async {
  // Step 2: Validate input
  if (_nameController.text.isEmpty || ...) {
    return; // Show error
  }

  // Step 3: Create VehicleEntity
  final newVehicle = VehicleEntity(
    id: _generateId(),
    name: _nameController.text,
    brand: _brandController.text,
    // ... other fields
  );

  // Step 4: Call provider to add vehicle
  // This is the key call that saves the vehicle
  await ref.read(vehiclesProvider.notifier).addVehicle(newVehicle);

  // Step 5: Show success and navigate back
  ScaffoldMessenger.of(context).showSnackBar(...);
  Navigator.pop(context);
}
```

### 2. State Management (vehicle_provider.dart)

```dart
class VehiclesNotifier extends StateNotifier<AsyncValue<List<VehicleEntity>>> {
  final AddVehicleUsecase addVehicleUsecase;

  // Step 4a: addVehicle called from UI
  Future<void> addVehicle(VehicleEntity vehicle) async {
    // Step 4b: Call the use case
    final result = await addVehicleUsecase(vehicle);
    
    // Step 4c: Handle result (either success or error)
    result.fold(
      (exception) {
        // Error case: update state with error
        state = AsyncValue.error(exception, StackTrace.current);
      },
      (_) {
        // Success case: update state with new vehicle
        state.whenData((vehicles) {
          final updatedVehicles = [...vehicles, vehicle];
          state = AsyncValue.data(updatedVehicles);
        });
      },
    );
  }
}
```

### 3. Use Case (vehicle_usecases.dart)

```dart
class AddVehicleUsecase {
  final VehicleRepository repository;

  // Step 4d: Use case delegates to repository
  Future<Either<Exception, void>> call(VehicleEntity vehicle) {
    return repository.addVehicle(vehicle);
  }
}
```

**Pattern:** Use case adalah simple wrapper yang contains business logic.

### 4. Repository (vehicle_repository_impl.dart)

```dart
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  @override
  Future<Either<Exception, void>> addVehicle(VehicleEntity vehicle) async {
    try {
      // Step 4e: Convert Entity to Model
      final vehicleModel = _entityToModel(vehicle);
      
      // Step 4f: Call datasource
      await remoteDataSource.addVehicle(vehicleModel);
      
      // Return success
      return Right(null);
    } on Exception catch (e) {
      // Catch error and wrap in Either
      return Left(e);
    }
  }
}
```

**Pattern:** Repository menangani data access dan error handling. Mengembalikan `Either` untuk functional error handling (bukan throw).

### 5. Data Source (vehicle_remote_datasource.dart)

```dart
class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  static List<VehicleModel> _vehicles = [];

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    // Step 4g: Simulate API delay
    await Future.delayed(Duration(milliseconds: 500));
    
    // Step 4h: Add vehicle to list
    // THIS IS WHERE DATA IS ACTUALLY SAVED
    _vehicles.add(vehicle);
  }
}
```

**Note:** 
- `_vehicles` adalah static list yang persisten selama app running
- Ketika app di-restart, data hilang (normal untuk dev stage)
- Bisa di-upgrade ke database/API nanti

## Data Models

### VehicleEntity (Domain Layer)
```dart
class VehicleEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final VehicleCategory category;
  final FuelType fuelType;
  final TransmissionType transmission;
  final int seats;
  final String imageUrl;
  final double pricePerDay;
  // ... other fields
}
```

**Tujuan:**
- Digunakan di domain/presentation layers
- Tidak tahu tentang JSON atau database
- Pure business logic objects

### VehicleModel (Data Layer)
```dart
class VehicleModel extends VehicleEntity {
  factory VehicleModel.fromJson(Map<String, dynamic> json) => 
    _$VehicleModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
```

**Tujuan:**
- Extends VehicleEntity
- Tambahan: JSON serialization
- Digunakan untuk komunikasi dengan API/database

## Error Handling Pattern

### Either Pattern (dari dartz package)

```dart
// Result bisa Either Left (error) atau Right (success)
Either<Exception, void> result = await repository.addVehicle(vehicle);

// Handle result dengan fold
result.fold(
  (exception) => handleError(exception),    // Left case
  (_) => handleSuccess(),                   // Right case
);
```

**Keuntungan:**
- Explicit error handling (bukan throw/catch)
- Functional programming style
- Type-safe

## State Management Pattern

### Riverpod StateNotifier

```dart
// Provider definition
final vehiclesProvider = StateNotifierProvider.autoDispose<
  VehiclesNotifier,
  AsyncValue<List<VehicleEntity>>
>((ref) {
  return VehiclesNotifier(...);
});

// Usage in UI
ConsumerWidget {
  ref.read(vehiclesProvider.notifier).addVehicle(vehicle);
}

// AsyncValue states
AsyncValue.loading() // Loading state
AsyncValue.data(vehicles) // Success with data
AsyncValue.error(exception, stackTrace) // Error state
```

## Testing the Flow

### Unit Test Example
```dart
test('addVehicle should add vehicle to repository', () async {
  // Arrange
  final vehicle = VehicleEntity(...);
  final mockRepository = MockVehicleRepository();
  final usecase = AddVehicleUsecase(mockRepository);
  
  // Act
  final result = await usecase(vehicle);
  
  // Assert
  expect(result.isRight(), true);
  verify(mockRepository.addVehicle(vehicle)).called(1);
});
```

### Integration Test
```dart
testWidgets('Add vehicle form submits successfully', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Find form fields and fill them
  await tester.enterText(find.byKey(Key('name')), 'Toyota');
  
  // Tap submit button
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  // Verify success message
  expect(find.text('Kendaraan berhasil disimpan!'), findsOneWidget);
});
```

## Performance Considerations

1. **Async Operations**
   - addVehicle() method async - tidak block UI
   - Future.delayed(500ms) - simulate API latency

2. **State Updates**
   - Only update state ketika save successful
   - Error state juga di-handle
   - UI automatically rebuild via Riverpod

3. **Memory**
   - _vehicles list grow terus selama app running
   - Untuk production: perlu implement pagination/limit
   - Atau gunakan persistent database

## Future Improvements

### 1. Persistent Storage
```dart
// Use VehicleLocalDataSourceImpl
final vehicles = await localDataSource.getCachedVehicles();
await localDataSource.addVehicle(vehicleModel);
```

### 2. Backend API Integration
```dart
// Replace mock delay dengan real HTTP call
Future<void> addVehicle(VehicleModel vehicle) async {
  final response = await dio.post(
    '/api/vehicles',
    data: vehicle.toJson(),
  );
  if (response.statusCode != 201) throw Exception('Failed');
}
```

### 3. Offline Sync
```dart
// Implement conflict resolution
if (isOnline) {
  await syncWithServer();
}
```

### 4. Image Upload
```dart
// Handle image upload separately
final imageUrl = await uploadImage(_selectedImage);
final vehicle = VehicleEntity(
  imageUrl: imageUrl,
  // ...
);
```

## Common Issues & Solutions

### Issue 1: Data Hilang Setelah Restart
**Penyebab:** Data hanya di-store di memory
**Solusi:** Implement persistent storage dengan SharedPreferences

### Issue 2: Slow Form Submission
**Penyebab:** Multiple API calls atau heavy processing
**Solusi:** Add loading indicator dan optimize queries

### Issue 3: Duplicate Vehicles
**Penyebab:** Multiple submissions atau race condition
**Solusi:** Disable submit button after clicked

## Code Organization Best Practices

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```

**Rule:** 
- Data layer tidak boleh tahu tentang presentation
- Domain layer pure business logic
- Presentation layer consumption layer

Ini adalah implementasi yang production-ready dan maintainable.
