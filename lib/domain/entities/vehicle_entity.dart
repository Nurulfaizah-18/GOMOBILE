import 'package:equatable/equatable.dart';

enum VehicleCategory {
  mobilKeluarga,
  mobilSport,
  mobilMewah,
  motor,
}

enum FuelType {
  bensin,
  diesel,
  hybrid,
  listrik,
}

enum TransmissionType {
  manual,
  otomatis,
}

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
  final String licensePlate;
  final int year;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String description;

  const VehicleEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.fuelType,
    required this.transmission,
    required this.seats,
    required this.imageUrl,
    required this.pricePerDay,
    required this.licensePlate,
    required this.year,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        category,
        fuelType,
        transmission,
        seats,
        imageUrl,
        pricePerDay,
        licensePlate,
        year,
        rating,
        reviewCount,
        isAvailable,
        description,
      ];
}
