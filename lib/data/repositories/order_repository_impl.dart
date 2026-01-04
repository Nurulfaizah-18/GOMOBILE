import 'package:dartz/dartz.dart';
import '../../domain/entities/rental_order_entity.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl();
  @override
  Future<Either<Exception, void>> cancelOrder(String orderId) async {
    try {
      // Note: Implement API call untuk production
      await Future.delayed(Duration(seconds: 1));
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, RentalOrderEntity>> createOrder(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Validate dates
      if (startDate.isAfter(endDate)) {
        return Left(Exception('Tanggal mulai harus sebelum tanggal akhir'));
      }

      if (startDate.isBefore(DateTime.now())) {
        return Left(Exception('Tanggal mulai tidak boleh di masa lalu'));
      }

      // Note: Implement API call untuk production
      await Future.delayed(const Duration(seconds: 1));

      // Create mock vehicle with basic data
      // In production, fetch actual vehicle from datasource
      final mockVehicle = VehicleEntity(
        id: vehicleId,
        name: 'Vehicle',
        brand: 'Brand',
        category: VehicleCategory.mobilKeluarga,
        fuelType: FuelType.bensin,
        transmission: TransmissionType.otomatis,
        seats: 5,
        imageUrl: 'https://via.placeholder.com/400x300?text=Vehicle',
        pricePerDay: 500000,
        licensePlate: 'B XXXX XXX',
        year: 2024,
        rating: 4.5,
        reviewCount: 10,
        isAvailable: true,
        description: 'Kendaraan rental',
      );

      final rentalDays = endDate.difference(startDate).inDays;
      final totalPrice = mockVehicle.pricePerDay * rentalDays;

      // Mock response
      final order = RentalOrderEntity(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        vehicle: mockVehicle,
        startDate: startDate,
        endDate: endDate,
        rentalDays: rentalDays,
        totalPrice: totalPrice,
        status: 'pending',
        createdAt: DateTime.now(),
      );
      return Right(order);
    } catch (e) {
      return Left(Exception('Gagal membuat pesanan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, RentalOrderEntity>> getOrderById(
      String orderId) async {
    try {
      // Note: Implement API call untuk production
      throw UnimplementedError();
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<RentalOrderEntity>>> getUserOrders() async {
    try {
      // Note: Implement API call untuk production
      await Future.delayed(Duration(seconds: 1));
      return Right([]);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
