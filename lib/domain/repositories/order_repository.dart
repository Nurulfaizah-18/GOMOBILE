import 'package:dartz/dartz.dart';
import '../entities/rental_order_entity.dart';

abstract class OrderRepository {
  Future<Either<Exception, RentalOrderEntity>> createOrder(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Exception, List<RentalOrderEntity>>> getUserOrders();
  Future<Either<Exception, RentalOrderEntity>> getOrderById(String orderId);
  Future<Either<Exception, void>> cancelOrder(String orderId);
}
