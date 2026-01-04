import 'package:dartz/dartz.dart';
import '../entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<Either<Exception, List<VehicleEntity>>> getAllVehicles();
  Future<Either<Exception, List<VehicleEntity>>> getVehiclesByCategory(
    VehicleCategory category,
  );
  Future<Either<Exception, VehicleEntity>> getVehicleById(String id);
  Future<Either<Exception, List<VehicleEntity>>> getPopularVehicles();
  Future<Either<Exception, List<VehicleEntity>>> searchVehicles(String query);
  Future<Either<Exception, void>> addVehicle(VehicleEntity vehicle);
  Future<Either<Exception, void>> updateVehicle(VehicleEntity vehicle);
  Future<Either<Exception, void>> deleteVehicle(String vehicleId);
}
