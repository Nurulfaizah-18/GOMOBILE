import 'package:dartz/dartz.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/vehicle_repository.dart';

class GetAllVehiclesUsecase {
  final VehicleRepository repository;

  GetAllVehiclesUsecase(this.repository);

  Future<Either<Exception, List<VehicleEntity>>> call() {
    return repository.getAllVehicles();
  }
}

class GetVehiclesByCategoryUsecase {
  final VehicleRepository repository;

  GetVehiclesByCategoryUsecase(this.repository);

  Future<Either<Exception, List<VehicleEntity>>> call(
      VehicleCategory category) {
    return repository.getVehiclesByCategory(category);
  }
}

class GetPopularVehiclesUsecase {
  final VehicleRepository repository;

  GetPopularVehiclesUsecase(this.repository);

  Future<Either<Exception, List<VehicleEntity>>> call() {
    return repository.getPopularVehicles();
  }
}

class GetVehicleByIdUsecase {
  final VehicleRepository repository;

  GetVehicleByIdUsecase(this.repository);

  Future<Either<Exception, VehicleEntity>> call(String vehicleId) {
    return repository.getVehicleById(vehicleId);
  }
}

class SearchVehiclesUsecase {
  final VehicleRepository repository;

  SearchVehiclesUsecase(this.repository);

  Future<Either<Exception, List<VehicleEntity>>> call(String query) {
    return repository.searchVehicles(query);
  }
}

class AddVehicleUsecase {
  final VehicleRepository repository;

  AddVehicleUsecase(this.repository);

  Future<Either<Exception, void>> call(VehicleEntity vehicle) {
    return repository.addVehicle(vehicle);
  }
}

class UpdateVehicleUsecase {
  final VehicleRepository repository;

  UpdateVehicleUsecase(this.repository);

  Future<Either<Exception, void>> call(VehicleEntity vehicle) {
    return repository.updateVehicle(vehicle);
  }
}

class DeleteVehicleUsecase {
  final VehicleRepository repository;

  DeleteVehicleUsecase(this.repository);

  Future<Either<Exception, void>> call(String vehicleId) {
    return repository.deleteVehicle(vehicleId);
  }
}
