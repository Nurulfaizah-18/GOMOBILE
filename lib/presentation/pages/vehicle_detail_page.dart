import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/cart_provider.dart';
import '../providers/date_range_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/date_range_picker_widget.dart';
import '../widgets/specification_item.dart';
import '../widgets/vehicle_card.dart';
import 'booking_page.dart';
import 'rental_form_page.dart';

class VehicleDetailPage extends ConsumerStatefulWidget {
  final VehicleEntity vehicle;

  const VehicleDetailPage({
    Key? key,
    required this.vehicle,
  }) : super(key: key);

  @override
  ConsumerState<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends ConsumerState<VehicleDetailPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  double _userRating = 0;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dateRange = ref.read(dateRangeProvider);
    _startDate = dateRange.startDate;
    _endDate = dateRange.endDate;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _endDate.difference(_startDate).inDays;
    final totalPrice =
        DateFormatter.calculateTotalPrice(widget.vehicle.pricePerDay, days);
    final isFavorite =
        ref.watch(favoritesProvider).any((v) => v.id == widget.vehicle.id);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        slivers: [
          // Image AppBar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.darkSurface,
            actions: [
              IconButton(
                onPressed: () {
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(widget.vehicle);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? '${widget.vehicle.name} dihapus dari favorit'
                            : '${widget.vehicle.name} ditambahkan ke favorit',
                      ),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.error : Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: AppColors.darkSurface,
                    child: VehicleImage(
                      imageUrl: widget.vehicle.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.darkBg.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Brand
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vehicle.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.vehicle.brand,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.vehicle.rating}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Specifications
                  Text(
                    'Spesifikasi Kendaraan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      SpecificationItem(
                        icon: Icons.event_seat,
                        label: 'Kursi',
                        value: '${widget.vehicle.seats} Orang',
                      ),
                      SpecificationItem(
                        icon: Icons.speed,
                        label: 'Transmisi',
                        value: widget.vehicle.transmission
                            .toString()
                            .split('.')
                            .last
                            .toUpperCase(),
                      ),
                      SpecificationItem(
                        icon: Icons.local_gas_station,
                        label: 'Bahan Bakar',
                        value: widget.vehicle.fuelType
                            .toString()
                            .split('.')
                            .last
                            .toUpperCase(),
                      ),
                      SpecificationItem(
                        icon: Icons.calendar_today,
                        label: 'Tahun',
                        value: '${widget.vehicle.year}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.vehicle.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Date Range Picker
                  DateRangePickerWidget(
                    initialStartDate: _startDate,
                    initialEndDate: _endDate,
                    onDateRangeSelected: (startDate, endDate) {
                      setState(() {
                        _startDate = startDate;
                        _endDate = endDate;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Rating and Review Section
                  Text(
                    'Beri Penilaian',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _userRating = (index + 1).toDouble();
                                });
                              },
                              child: Icon(
                                Icons.star,
                                size: 40,
                                color: index < _userRating
                                    ? Colors.amber
                                    : AppColors.borderColor,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _reviewController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Tulis ulasan Anda...',
                            hintStyle: const TextStyle(color: AppColors.borderColor),
                            filled: true,
                            fillColor: AppColors.darkBg,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppColors.borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppColors.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.electricBlue,
                              ),
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _userRating > 0
                                ? () {
                                    // Handle rating submission
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Terima kasih untuk penilaian $_userRating bintang!',
                                        ),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                    setState(() {
                                      _userRating = 0;
                                      _reviewController.clear();
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.electricBlue,
                              disabledBackgroundColor: AppColors.borderColor,
                            ),
                            child: const Text('Kirim Penilaian'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Price Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Harga Per Hari',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              DateFormatter.formatPrice(
                                widget.vehicle.pricePerDay,
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jumlah Hari ($days hari)',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              '${days}x',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.borderColor),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Harga',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              DateFormatter.formatPrice(totalPrice),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppColors.electricBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Booking Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalFormPage(
                              vehicle: widget.vehicle,
                              initialStartDate: _startDate,
                              initialEndDate: _endDate,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.car_rental),
                      label: const Text('Sewa Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quick Booking Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(
                              vehicle: widget.vehicle,
                              startDate: _startDate,
                              endDate: _endDate,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Booking Cepat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.electricBlue,
                        side: const BorderSide(color: AppColors.electricBlue),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addToCart(
                              widget.vehicle,
                              _startDate,
                              _endDate,
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.vehicle.name} ditambahkan ke keranjang',
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Tambah ke Keranjang'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
