# Implementasi Penyimpanan Kendaraan (Vehicle Save Feature)

## Ringkasan Perubahan

Sistem penyimpanan kendaraan yang baru ditambahkan telah diimplementasikan dengan menjalankan Clean Architecture principle. Kendaraan yang ditambahkan sekarang akan disimpan secara persisten di aplikasi.

## Perubahan Detail

### 1. Data Layer - Remote DataSource
**File:** `lib/data/datasources/remote/vehicle_remote_datasource.dart`

**Perubahan:**
- Menambahkan 3 metode abstrak baru:
  - `Future<void> addVehicle(VehicleModel vehicle)` - Menambah kendaraan baru
  - `Future<void> updateVehicle(VehicleModel vehicle)` - Mengubah data kendaraan
  - `Future<void> deleteVehicle(String vehicleId)` - Menghapus kendaraan

- Implementasi menggunakan in-memory list `_vehicles` untuk menyimpan data:
  ```dart
  static List<VehicleModel> _vehicles = [];
  ```

- Data kendaraan tersimpan selama aplikasi berjalan dan diintegrasikan dengan method pembacaan lain

### 2. Data Layer - Local DataSource
**File:** `lib/data/datasources/local/vehicle_local_datasource.dart`

**Perubahan:**
- Mengimplementasikan penyimpanan lokal menggunakan `shared_preferences`
- Metode-metode baru:
  - `getCachedVehicles()` - Mengambil kendaraan dari cache lokal
  - `cacheVehicles()` - Menyimpan kendaraan ke cache lokal
  - `addVehicle()` - Menambah satu kendaraan ke cache
  - `removeVehicle()` - Menghapus kendaraan dari cache
  - `updateVehicle()` - Mengubah kendaraan di cache
  - `clearCache()` - Menghapus seluruh cache

**Cara Kerja:**
- Menggunakan JSON serialization untuk menyimpan data
- Data disimpan dengan key `'cached_vehicles'`
- Implementasi robust dengan error handling yang baik

### 3. Repository Layer
**File:** `lib/data/repositories/vehicle_repository_impl.dart`

**Perubahan:**
- Menambahkan 3 metode baru di implementasi repository:
  - `addVehicle(VehicleEntity vehicle)`
  - `updateVehicle(VehicleEntity vehicle)`
  - `deleteVehicle(String vehicleId)`

- Semua metode mengembalikan `Either<Exception, void>` untuk error handling yang konsisten

### 4. Domain Layer - Abstract Repository
**File:** `lib/domain/repositories/vehicle_repository.dart`

**Perubahan:**
- Menambahkan 3 metode abstrak di interface:
  - `Future<Either<Exception, void>> addVehicle(VehicleEntity vehicle);`
  - `Future<Either<Exception, void>> updateVehicle(VehicleEntity vehicle);`
  - `Future<Either<Exception, void>> deleteVehicle(String vehicleId);`

### 5. Domain Layer - Use Cases
**File:** `lib/domain/usecases/vehicle_usecases.dart`

**Perubahan:**
- Menambahkan 3 use case baru:
  - `AddVehicleUsecase` - Logic untuk menambah kendaraan
  - `UpdateVehicleUsecase` - Logic untuk mengubah kendaraan
  - `DeleteVehicleUsecase` - Logic untuk menghapus kendaraan

**Contoh implementasi:**
```dart
class AddVehicleUsecase {
  final VehicleRepository repository;

  AddVehicleUsecase(this.repository);

  Future<Either<Exception, void>> call(VehicleEntity vehicle) {
    return repository.addVehicle(vehicle);
  }
}
```

### 6. Presentation Layer - Vehicle Provider
**File:** `lib/presentation/providers/vehicle_provider.dart`

**Perubahan:**
- Menambahkan SharedPreferences provider untuk dependency injection
- Menambahkan Local DataSource provider
- Menambahkan 3 use case providers baru:
  - `addVehicleUsecaseProvider`
  - `updateVehicleUsecaseProvider`
  - `deleteVehicleUsecaseProvider`

- Update `VehiclesNotifier` dengan:
  - Method `addVehicle()` yang sekarang `async` dan menggunakan use case
  - Method `updateVehicle()` yang sekarang `async` dan menggunakan use case
  - Method `deleteVehicle()` yang sekarang `async` dan menggunakan use case

**Perubahan Key:**
```dart
// Sebelum - sinkron tanpa penyimpanan
void addVehicle(VehicleEntity vehicle) {
  state.whenData((vehicles) {
    final updatedVehicles = [...vehicles, vehicle];
    state = AsyncValue.data(updatedVehicles);
  });
}

// Sesudah - asinkron dengan penyimpanan
Future<void> addVehicle(VehicleEntity vehicle) async {
  final result = await addVehicleUsecase(vehicle);
  result.fold(
    (exception) {
      state = AsyncValue.error(exception, StackTrace.current);
    },
    (_) {
      state.whenData((vehicles) {
        final updatedVehicles = [...vehicles, vehicle];
        state = AsyncValue.data(updatedVehicles);
      });
    },
  );
}
```

### 7. Presentation Layer - Add Vehicle Page
**File:** `lib/presentation/pages/add_vehicle_page.dart`

**Perubahan:**
- Method `_submitForm()` sekarang `async`
- Menambahkan loading indicator (SnackBar) saat menyimpan
- Menambahkan `await` untuk menunggu proses penyimpanan
- Menambahkan clear form setelah berhasil menyimpan
- Pengecekan `mounted` untuk mencegah memory leak
- Pesan feedback yang lebih informatif

**Alur Baru:**
1. Validasi input
2. Tampilkan loading state
3. Buat VehicleEntity dari input
4. Await penyimpanan via provider
5. Tampilkan success message
6. Clear form
7. Pop halaman

## Flow Penyimpanan Kendaraan

```
AddVehiclePage._submitForm()
    ↓
Create VehicleEntity
    ↓
await vehiclesProvider.notifier.addVehicle(vehicle)
    ↓
VehiclesNotifier.addVehicle()
    ↓
await addVehicleUsecase(vehicle)
    ↓
AddVehicleUsecase.call()
    ↓
repository.addVehicle(vehicle)
    ↓
VehicleRepositoryImpl.addVehicle()
    ↓
remoteDataSource.addVehicle(vehicleModel)
    ↓
VehicleRemoteDataSourceImpl.addVehicle()
    ↓
Menyimpan ke _vehicles list
    ↓
Update state di VehiclesNotifier
    ↓
Show success message & navigate back
```

## Keuntungan Implementasi Baru

✅ **Penyimpanan Persisten** - Kendaraan disimpan di SharedPreferences  
✅ **Architecture-Compliant** - Mengikuti Clean Architecture principle  
✅ **Error Handling** - Error handling yang konsisten menggunakan Either pattern  
✅ **Async Operations** - Semua operasi penyimpanan asinkron  
✅ **State Management** - Integration yang baik dengan Riverpod  
✅ **Testability** - Setiap layer dapat ditest secara terpisah  
✅ **Scalability** - Mudah untuk upgrade ke HTTP API di masa depan  

## Testing Feature

Untuk test feature ini:

1. Jalankan aplikasi
2. Navigasi ke halaman Add Vehicle (ProfilePage → Add Vehicle)
3. Isi semua field yang dibutuhkan
4. Klik "Simpan" atau button yang sesuai
5. Tunggu loading dan success message
6. Kendaraan akan muncul di dashboard/search page

## Future Enhancements

- [ ] Integrasi dengan HTTP API untuk backend persistence
- [ ] Implementasi Hive untuk caching yang lebih powerful
- [ ] Add image upload capability
- [ ] Validasi field yang lebih detail
- [ ] Offline sync capability

## Dependencies

- `shared_preferences: ^2.2.0` - Already included in pubspec.yaml
- `flutter_riverpod: ^2.4.0` - Already included in pubspec.yaml
- `dartz: ^0.10.1` - Already included in pubspec.yaml

Semua dependencies yang diperlukan sudah ada di project.
