import 'vehicle_entity.dart';
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final VehicleEntity vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final int rentalDays;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.rentalDays,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        vehicle,
        startDate,
        endDate,
        rentalDays,
        totalPrice,
      ];
}
