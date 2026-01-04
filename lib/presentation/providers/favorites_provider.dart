import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/vehicle_entity.dart';

class FavoritesNotifier extends StateNotifier<List<VehicleEntity>> {
  FavoritesNotifier() : super([]);

  void addToFavorites(VehicleEntity vehicle) {
    if (!state.any((v) => v.id == vehicle.id)) {
      state = [...state, vehicle];
    }
  }

  void removeFromFavorites(String vehicleId) {
    state = state.where((v) => v.id != vehicleId).toList();
  }

  void toggleFavorite(VehicleEntity vehicle) {
    if (state.any((v) => v.id == vehicle.id)) {
      removeFromFavorites(vehicle.id);
    } else {
      addToFavorites(vehicle);
    }
  }

  bool isFavorite(String vehicleId) {
    return state.any((v) => v.id == vehicleId);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<VehicleEntity>>((ref) {
  return FavoritesNotifier();
});
