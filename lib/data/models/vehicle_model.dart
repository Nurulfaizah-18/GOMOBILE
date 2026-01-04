import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/vehicle_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required String id,
    required String name,
    required String brand,
    required VehicleCategory category,
    required FuelType fuelType,
    required TransmissionType transmission,
    required int seats,
    required String imageUrl,
    required double pricePerDay,
    required String licensePlate,
    required int year,
    required double rating,
    required int reviewCount,
    required bool isAvailable,
    required String description,
  }) : super(
          id: id,
          name: name,
          brand: brand,
          category: category,
          fuelType: fuelType,
          transmission: transmission,
          seats: seats,
          imageUrl: imageUrl,
          pricePerDay: pricePerDay,
          licensePlate: licensePlate,
          year: year,
          rating: rating,
          reviewCount: reviewCount,
          isAvailable: isAvailable,
          description: description,
        );

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  // Data kendaraan - kosong untuk production
  // Admin dapat menambahkan kendaraan melalui menu Kelola Kendaraan
  static List<VehicleModel> getMockVehicles() {
    return []; // Kosong - data akan ditambahkan oleh admin
  }
}
