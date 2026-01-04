import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/vehicle_remote_datasource.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/usecases/vehicle_usecases.dart';

// Datasources
final vehicleRemoteDataSourceProvider =
    Provider((ref) => VehicleRemoteDataSourceImpl());

// Repositories
final vehicleRepositoryProvider = Provider((ref) {
  return VehicleRepositoryImpl(
    remoteDataSource: ref.watch(vehicleRemoteDataSourceProvider),
  );
});

// Use Cases
final getAllVehiclesUsecaseProvider = Provider((ref) {
  return GetAllVehiclesUsecase(ref.watch(vehicleRepositoryProvider));
});

final getVehiclesByCategoryUsecaseProvider = Provider((ref) {
  return GetVehiclesByCategoryUsecase(ref.watch(vehicleRepositoryProvider));
});

final getPopularVehiclesUsecaseProvider = Provider((ref) {
  return GetPopularVehiclesUsecase(ref.watch(vehicleRepositoryProvider));
});

final getVehicleByIdUsecaseProvider = Provider((ref) {
  return GetVehicleByIdUsecase(ref.watch(vehicleRepositoryProvider));
});

final searchVehiclesUsecaseProvider = Provider((ref) {
  return SearchVehiclesUsecase(ref.watch(vehicleRepositoryProvider));
});

final addVehicleUsecaseProvider = Provider((ref) {
  return AddVehicleUsecase(ref.watch(vehicleRepositoryProvider));
});

final updateVehicleUsecaseProvider = Provider((ref) {
  return UpdateVehicleUsecase(ref.watch(vehicleRepositoryProvider));
});

final deleteVehicleUsecaseProvider = Provider((ref) {
  return DeleteVehicleUsecase(ref.watch(vehicleRepositoryProvider));
});

// State Notifiers
class VehiclesNotifier extends StateNotifier<AsyncValue<List<VehicleEntity>>> {
  final GetAllVehiclesUsecase getAllVehiclesUsecase;
  final AddVehicleUsecase addVehicleUsecase;
  final UpdateVehicleUsecase updateVehicleUsecase;
  final DeleteVehicleUsecase deleteVehicleUsecase;

  VehiclesNotifier({
    required this.getAllVehiclesUsecase,
    required this.addVehicleUsecase,
    required this.updateVehicleUsecase,
    required this.deleteVehicleUsecase,
  }) : super(const AsyncValue.loading()) {
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final result = await getAllVehiclesUsecase();
    state = result.fold(
      (exception) => AsyncValue.error(exception, StackTrace.current),
      (vehicles) => AsyncValue.data(vehicles),
    );
  }

  Future<void> refresh() => _loadVehicles();

  // Add new vehicle
  Future<void> addVehicle(VehicleEntity vehicle) async {
    final result = await addVehicleUsecase(vehicle);
    result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
      },
      (_) {
        // Reload dari datasource untuk menghindari duplikasi
        _loadVehicles();
      },
    );
  }

  // Delete vehicle by id
  Future<void> deleteVehicle(String vehicleId) async {
    final result = await deleteVehicleUsecase(vehicleId);
    result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
      },
      (_) {
        state.whenData((vehicles) {
          final updatedVehicles =
              vehicles.where((v) => v.id != vehicleId).toList();
          state = AsyncValue.data(updatedVehicles);
        });
      },
    );
  }

  // Update vehicle
  Future<void> updateVehicle(VehicleEntity vehicle) async {
    final result = await updateVehicleUsecase(vehicle);
    result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
      },
      (_) {
        state.whenData((vehicles) {
          final updatedVehicles =
              vehicles.map((v) => v.id == vehicle.id ? vehicle : v).toList();
          state = AsyncValue.data(updatedVehicles);
        });
      },
    );
  }
}

final vehiclesProvider =
    StateNotifierProvider<VehiclesNotifier, AsyncValue<List<VehicleEntity>>>(
        (ref) {
  return VehiclesNotifier(
    getAllVehiclesUsecase: ref.watch(getAllVehiclesUsecaseProvider),
    addVehicleUsecase: ref.watch(addVehicleUsecaseProvider),
    updateVehicleUsecase: ref.watch(updateVehicleUsecaseProvider),
    deleteVehicleUsecase: ref.watch(deleteVehicleUsecaseProvider),
  );
});

// Popular Vehicles Provider
final popularVehiclesProvider =
    FutureProvider<List<VehicleEntity>>((ref) async {
  final usecase = ref.watch(getPopularVehiclesUsecaseProvider);
  final result = await usecase();
  return result.fold(
    (exception) => throw exception,
    (vehicles) => vehicles,
  );
});

// Selected Category Provider
final selectedCategoryProvider =
    StateProvider<VehicleCategory>((ref) => VehicleCategory.mobilKeluarga);

// Vehicles by Category Provider
final vehiclesByCategoryProvider = FutureProvider<List<VehicleEntity>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final usecase = ref.watch(getVehiclesByCategoryUsecaseProvider);
  return usecase(category).then(
    (result) => result.fold(
      (exception) => throw exception,
      (vehicles) => vehicles,
    ),
  );
});

// Vehicle Detail Provider
final vehicleDetailProvider =
    FutureProvider.family<VehicleEntity, String>((ref, vehicleId) {
  final usecase = ref.watch(getVehicleByIdUsecaseProvider);
  return usecase(vehicleId).then(
    (result) => result.fold(
      (exception) => throw exception,
      (vehicle) => vehicle,
    ),
  );
});

// Search Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<VehicleEntity>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final usecase = ref.watch(searchVehiclesUsecaseProvider);
  return usecase(query).then(
    (result) => result.fold(
      (exception) => throw exception,
      (vehicles) => vehicles,
    ),
  );
});
