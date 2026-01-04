import 'package:dartz/dartz.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/remote/vehicle_remote_datasource.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<VehicleEntity>>> getAllVehicles() async {
    try {
      final vehicles = await remoteDataSource.getAllVehicles();
      return Right(vehicles);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<VehicleEntity>>> getVehiclesByCategory(
    VehicleCategory category,
  ) async {
    try {
      final vehicles = await remoteDataSource
          .getVehiclesByCategory(category.toString().split('.').last);
      return Right(vehicles);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, VehicleEntity>> getVehicleById(String id) async {
    try {
      final vehicle = await remoteDataSource.getVehicleById(id);
      return Right(vehicle);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<VehicleEntity>>> getPopularVehicles() async {
    try {
      final vehicles = await remoteDataSource.getPopularVehicles();
      return Right(vehicles);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<VehicleEntity>>> searchVehicles(
      String query) async {
    try {
      final vehicles = await remoteDataSource.searchVehicles(query);
      return Right(vehicles);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addVehicle(VehicleEntity vehicle) async {
    try {
      final vehicleModel = _entityToModel(vehicle);
      await remoteDataSource.addVehicle(vehicleModel);
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateVehicle(VehicleEntity vehicle) async {
    try {
      final vehicleModel = _entityToModel(vehicle);
      await remoteDataSource.updateVehicle(vehicleModel);
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> deleteVehicle(String vehicleId) async {
    try {
      await remoteDataSource.deleteVehicle(vehicleId);
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  // Helper method untuk convert Entity ke Model
  VehicleModel _entityToModel(VehicleEntity entity) {
    if (entity is VehicleModel) {
      return entity;
    }
    return VehicleModel(
      id: entity.id,
      name: entity.name,
      brand: entity.brand,
      category: entity.category,
      fuelType: entity.fuelType,
      transmission: entity.transmission,
      seats: entity.seats,
      imageUrl: entity.imageUrl,
      pricePerDay: entity.pricePerDay,
      licensePlate: entity.licensePlate,
      year: entity.year,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      isAvailable: entity.isAvailable,
      description: entity.description,
    );
  }
}
