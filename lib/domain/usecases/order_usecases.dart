import 'package:dartz/dartz.dart';
import '../../domain/entities/rental_order_entity.dart';
import '../../domain/repositories/order_repository.dart';

class CreateOrderUsecase {
  final OrderRepository repository;

  CreateOrderUsecase(this.repository);

  Future<Either<Exception, RentalOrderEntity>> call(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return repository.createOrder(vehicleId, startDate, endDate);
  }
}

class GetUserOrdersUsecase {
  final OrderRepository repository;

  GetUserOrdersUsecase(this.repository);

  Future<Either<Exception, List<RentalOrderEntity>>> call() {
    return repository.getUserOrders();
  }
}

class GetOrderByIdUsecase {
  final OrderRepository repository;

  GetOrderByIdUsecase(this.repository);

  Future<Either<Exception, RentalOrderEntity>> call(String orderId) {
    return repository.getOrderById(orderId);
  }
}

class CancelOrderUsecase {
  final OrderRepository repository;

  CancelOrderUsecase(this.repository);

  Future<Either<Exception, void>> call(String orderId) {
    return repository.cancelOrder(orderId);
  }
}
