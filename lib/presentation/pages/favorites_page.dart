import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../widgets/vehicle_card.dart';
import 'vehicle_detail_page.dart';
import 'edit_vehicle_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Text('Kendaraan Favorit'),
        centerTitle: false,
      ),
      body: favorites.isEmpty
          ? _buildEmptyState(context)
          : Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final vehicle = favorites[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VehicleDetailPage(vehicle: vehicle),
                        ),
                      );
                    },
                    child: VehicleCard(
                      imageUrl: vehicle.imageUrl,
                      name: vehicle.name,
                      brand: vehicle.brand,
                      rating: vehicle.rating,
                      reviewCount: vehicle.reviewCount,
                      pricePerDay: vehicle.pricePerDay,
                      isFavorite: true,
                      onFavoriteTap: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .removeFromFavorites(vehicle.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${vehicle.name} dihapus dari favorit',
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VehicleDetailPage(vehicle: vehicle),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditVehiclePage(vehicle: vehicle),
                          ),
                        );
                      },
                      onDelete: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .removeFromFavorites(vehicle.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Kendaraan "${vehicle.name}" dihapus'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'Belum Ada Favorit',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Tambahkan kendaraan ke favorit untuk melihatnya di sini',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
