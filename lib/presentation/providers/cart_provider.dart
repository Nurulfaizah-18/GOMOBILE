import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../core/utils/date_formatter.dart';

// Cart Notifier
class CartNotifier extends StateNotifier<List<CartItemEntity>> {
  CartNotifier() : super([]);

  void addToCart(
    VehicleEntity vehicle,
    DateTime startDate,
    DateTime endDate,
  ) {
    final rentalDays =
        DateFormatter.calculateDaysDifference(startDate, endDate);
    final totalPrice =
        DateFormatter.calculateTotalPrice(vehicle.pricePerDay, rentalDays);

    final cartItem = CartItemEntity(
      id: '${vehicle.id}_${DateTime.now().millisecondsSinceEpoch}',
      vehicle: vehicle,
      startDate: startDate,
      endDate: endDate,
      rentalDays: rentalDays,
      totalPrice: totalPrice,
    );

    state = [...state, cartItem];
  }

  void addItem({
    required String vehicleId,
    required String vehicleName,
    required DateTime startDate,
    required DateTime endDate,
    required double pricePerDay,
    required double totalPrice,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String notes,
  }) {
    // Placeholder implementation
    // Integrate with actual vehicle data later
  }

  void removeFromCart(String cartItemId) {
    state = state.where((item) => item.id != cartItemId).toList();
  }

  void clearCart() {
    state = [];
  }

  double getTotalPrice() {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int getCartCount() {
    return state.length;
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemEntity>>((ref) {
  return CartNotifier();
});

// Cart total price provider
final cartTotalPriceProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});

// Cart count provider
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});
