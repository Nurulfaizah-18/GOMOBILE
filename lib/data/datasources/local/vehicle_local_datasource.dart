import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/vehicle_model.dart';

abstract class VehicleLocalDataSource {
  Future<List<VehicleModel>> getCachedVehicles();
  Future<void> cacheVehicles(List<VehicleModel> vehicles);
  Future<void> clearCache();
  Future<void> addVehicle(VehicleModel vehicle);
  Future<void> removeVehicle(String vehicleId);
  Future<void> updateVehicle(VehicleModel vehicle);
}

class VehicleLocalDataSourceImpl implements VehicleLocalDataSource {
  static const String _vehiclesCacheKey = 'cached_vehicles';

  final SharedPreferences sharedPreferences;

  VehicleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<VehicleModel>> getCachedVehicles() async {
    try {
      final jsonString = sharedPreferences.getString(_vehiclesCacheKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get cached vehicles: $e');
    }
  }

  @override
  Future<void> cacheVehicles(List<VehicleModel> vehicles) async {
    try {
      final jsonList = vehicles.map((v) => v.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(_vehiclesCacheKey, jsonString);
    } catch (e) {
      throw Exception('Failed to cache vehicles: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_vehiclesCacheKey);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    try {
      final vehicles = await getCachedVehicles();
      vehicles.add(vehicle);
      await cacheVehicles(vehicles);
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }

  @override
  Future<void> removeVehicle(String vehicleId) async {
    try {
      final vehicles = await getCachedVehicles();
      vehicles.removeWhere((v) => v.id == vehicleId);
      await cacheVehicles(vehicles);
    } catch (e) {
      throw Exception('Failed to remove vehicle: $e');
    }
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
      final vehicles = await getCachedVehicles();
      final index = vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        vehicles[index] = vehicle;
        await cacheVehicles(vehicles);
      } else {
        throw Exception('Vehicle not found');
      }
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }
}
