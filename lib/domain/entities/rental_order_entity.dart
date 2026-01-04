import 'package:equatable/equatable.dart';
import 'vehicle_entity.dart';

class RentalOrderEntity extends Equatable {
  final String id;
  final VehicleEntity vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDays;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  const RentalOrderEntity({
    required this.id,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.rentalDays,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        vehicle,
        startDate,
        endDate,
        rentalDays,
        totalPrice,
        status,
        createdAt,
      ];
}
