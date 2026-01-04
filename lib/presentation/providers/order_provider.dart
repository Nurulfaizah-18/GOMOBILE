import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/datasources/remote/vehicle_remote_datasource.dart';
import '../../domain/usecases/order_usecases.dart';
import '../../domain/entities/rental_order_entity.dart';
import '../../data/services/local_storage_service.dart';

final vehicleRemoteDataSourceProvider =
    Provider((ref) => VehicleRemoteDataSourceImpl());

final orderRepositoryProvider = Provider((ref) => OrderRepositoryImpl());

final createOrderUsecaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CreateOrderUsecase(repository);
});

final getUserOrdersUsecaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetUserOrdersUsecase(repository);
});

final cancelOrderUsecaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CancelOrderUsecase(repository);
});

// State notifier untuk manage orders with persistent storage
class OrdersNotifier extends StateNotifier<List<RentalOrderEntity>> {
  final CreateOrderUsecase _createOrderUsecase;
  final GetUserOrdersUsecase _getUserOrdersUsecase;

  OrdersNotifier(this._createOrderUsecase, this._getUserOrdersUsecase)
      : super([]) {
    // Load orders from storage on init
    _loadOrdersFromStorage();
  }

  // Load orders from LocalStorageService
  void _loadOrdersFromStorage() {
    final orders = LocalStorageService.loadOrders();
    if (orders.isNotEmpty) {
      state = orders;
    }
  }

  // Save orders to LocalStorageService
  Future<void> _saveOrdersToStorage() async {
    await LocalStorageService.saveOrders(state);
  }

  // Tambah order langsung dengan objek RentalOrderEntity
  void addOrder(RentalOrderEntity order) {
    state = [...state, order];
    _saveOrdersToStorage();
  }

  // Update status order
  void updateOrderStatus(String orderId, String newStatus) {
    state = state.map((order) {
      if (order.id == orderId) {
        return RentalOrderEntity(
          id: order.id,
          vehicle: order.vehicle,
          startDate: order.startDate,
          endDate: order.endDate,
          rentalDays: order.rentalDays,
          totalPrice: order.totalPrice,
          status: newStatus,
          createdAt: order.createdAt,
        );
      }
      return order;
    }).toList();
    _saveOrdersToStorage();
  }

  // Hapus order
  void removeOrder(String orderId) {
    state = state.where((order) => order.id != orderId).toList();
    _saveOrdersToStorage();
  }

  // Update orders dari list baru
  void updateOrders(List<RentalOrderEntity> newOrders) {
    state = newOrders;
    _saveOrdersToStorage();
  }

  Future<void> createOrder(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await _createOrderUsecase(vehicleId, startDate, endDate);
    result.fold(
      (error) {
        // Handle error
        throw error;
      },
      (order) {
        // Add order to state
        state = [...state, order];
        _saveOrdersToStorage();
      },
    );
  }

  Future<void> loadUserOrders() async {
    final result = await _getUserOrdersUsecase();
    result.fold(
      (error) {
        // Handle error
        throw error;
      },
      (orders) {
        state = orders;
        _saveOrdersToStorage();
      },
    );
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<RentalOrderEntity>>((ref) {
  final createOrderUsecase = ref.watch(createOrderUsecaseProvider);
  final getUserOrdersUsecase = ref.watch(getUserOrdersUsecaseProvider);
  return OrdersNotifier(createOrderUsecase, getUserOrdersUsecase);
});
