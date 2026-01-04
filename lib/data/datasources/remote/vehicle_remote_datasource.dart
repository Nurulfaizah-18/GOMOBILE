import '../../models/vehicle_model.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../services/local_storage_service.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getAllVehicles();
  Future<List<VehicleModel>> getVehiclesByCategory(String category);
  Future<VehicleModel> getVehicleById(String id);
  Future<List<VehicleModel>> getPopularVehicles();
  Future<List<VehicleModel>> searchVehicles(String query);
  Future<void> addVehicle(VehicleModel vehicle);
  Future<void> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String vehicleId);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  // Persistent storage using LocalStorageService

  // Default vehicle if storage is empty
  static const VehicleModel _defaultVehicle = VehicleModel(
    id: 'V001',
    name: 'Avanza',
    brand: 'Toyota',
    category: VehicleCategory.mobilKeluarga,
    fuelType: FuelType.bensin,
    transmission: TransmissionType.manual,
    seats: 7,
    imageUrl:
        'https://imgcdn.oto.com/large/gallery/exterior/20/2414/toyota-avanza-front-angle-low-view-702498.jpg',
    pricePerDay: 350000,
    licensePlate: 'B 1234 ABC',
    year: 2023,
    rating: 4.5,
    reviewCount: 120,
    isAvailable: true,
    description:
        'Toyota Avanza adalah mobil MPV keluarga yang nyaman dan irit bahan bakar. Cocok untuk perjalanan keluarga.',
  );

  Future<List<VehicleModel>> _loadVehicles() async {
    final vehicles = LocalStorageService.loadVehicles();

    if (vehicles.isEmpty) {
      // Initialize with default vehicle
      await LocalStorageService.saveVehicles([_defaultVehicle]);
      return [_defaultVehicle];
    }

    // Convert VehicleEntity to VehicleModel
    return vehicles
        .map((v) => VehicleModel(
              id: v.id,
              name: v.name,
              brand: v.brand,
              category: v.category,
              fuelType: v.fuelType,
              transmission: v.transmission,
              seats: v.seats,
              imageUrl: v.imageUrl,
              pricePerDay: v.pricePerDay,
              licensePlate: v.licensePlate,
              year: v.year,
              rating: v.rating,
              reviewCount: v.reviewCount,
              isAvailable: v.isAvailable,
              description: v.description,
            ))
        .toList();
  }

  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    // Simulasi API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _loadVehicles();
  }

  @override
  Future<List<VehicleModel>> getVehiclesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allVehicles = await _loadVehicles();
    // Filter berdasarkan kategori
    return allVehicles
        .where((vehicle) => vehicle.category.toString().contains(category))
        .toList();
  }

  @override
  Future<VehicleModel> getVehicleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final allVehicles = await _loadVehicles();
    return allVehicles.firstWhere((vehicle) => vehicle.id == id);
  }

  @override
  Future<List<VehicleModel>> getPopularVehicles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allVehicles = await _loadVehicles();
    // Urutkan berdasarkan rating dan jumlah review
    allVehicles.sort((a, b) {
      final aScore = a.rating * a.reviewCount;
      final bScore = b.rating * b.reviewCount;
      return bScore.compareTo(aScore);
    });
    return allVehicles.take(4).toList();
  }

  @override
  Future<List<VehicleModel>> searchVehicles(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allVehicles = await _loadVehicles();
    final lowerQuery = query.toLowerCase();
    return allVehicles
        .where((vehicle) =>
            vehicle.name.toLowerCase().contains(lowerQuery) ||
            vehicle.brand.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final vehicles = await _loadVehicles();
    vehicles.add(vehicle);
    await LocalStorageService.saveVehicles(vehicles);
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final vehicles = await _loadVehicles();
    final index = vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      vehicles[index] = vehicle;
      await LocalStorageService.saveVehicles(vehicles);
    }
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final vehicles = await _loadVehicles();
    vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
    await LocalStorageService.saveVehicles(vehicles);
  }
}
