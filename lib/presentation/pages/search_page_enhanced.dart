import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/enhanced_ui_widgets.dart';
import '../widgets/animation_widgets.dart';
import 'vehicle_detail_page.dart';

class SearchPageEnhanced extends ConsumerWidget {
  const SearchPageEnhanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        slivers: [
          // Enhanced Search Bar in AppBar
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricBlue.withValues(alpha: 0.1),
                      AppColors.darkBg,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        'Cari Kendaraan',
                        gradient: LinearGradient(
                          colors: [
                            AppColors.electricBlue,
                            AppColors.electricBlueDark,
                          ],
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search and Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Search Bar
                  AnimatedSearchBar(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'Semua',
                          Icons.apps,
                          true,
                          () {},
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Rating Tinggi',
                          Icons.star,
                          false,
                          () {},
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Harga Rendah',
                          Icons.attach_money,
                          false,
                          () {},
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Baru',
                          Icons.new_releases,
                          false,
                          () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Results Info
                  if (searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Hasil pencarian untuk "$searchQuery"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.electricBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),

                  // Search Results Grid
                  searchResults.when(
                    data: (results) {
                      if (results.isEmpty && searchQuery.isNotEmpty) {
                        return _buildEmptySearchState(context);
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final vehicle = results[index];
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
                            child: EnhancedVehicleCard(
                              name: vehicle.name,
                              image: vehicle.imageUrl,
                              price: 'Rp ${vehicle.pricePerDay}/hari',
                              rating: vehicle.rating,
                              reviews: vehicle.reviewCount,
                              isFavorite: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VehicleDetailPage(vehicle: vehicle),
                                  ),
                                );
                              },
                              onFavoriteTap: () {},
                            ),
                          );
                        },
                      );
                    },
                    loading: () => SizedBox(
                      height: 400,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: PulseLoadingWidget(size: 60),
                            ),
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.electricBlue,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat hasil pencarian',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.electricBlue : AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.electricBlue : AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.electricBlue.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Hasil',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba dengan kata kunci yang berbeda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Placeholder providers - implement sesuai kebutuhan
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider((ref) async {
  // Implement search logic here
  return [];
});
