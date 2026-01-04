import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/vehicle_provider.dart';
import '../providers/order_provider.dart';

/// Halaman Laporan untuk Admin
class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime(2026, 1, 1);

  // Nama bulan dalam Bahasa Indonesia
  final List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  String get _formattedPeriod =>
      '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.electricBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.darkBg,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        title: const Text(
          'Laporan & Analitik',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.electricBlue),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.electricBlue,
          labelColor: AppColors.electricBlue,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Pendapatan'),
            Tab(text: 'Kendaraan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildRevenueTab(),
          _buildVehicleTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    // Ambil data dari provider
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final orders = ref.watch(ordersProvider);

    return vehiclesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (vehicles) {
        // Hitung statistik
        final totalVehicles = vehicles.length;
        final availableVehicles = vehicles.where((v) => v.isAvailable).length;
        final rentedVehicles = totalVehicles - availableVehicles;

        // Filter orders berdasarkan bulan dan tahun yang dipilih
        final filteredOrders = orders.where((order) {
          return order.createdAt.month == _selectedDate.month &&
              order.createdAt.year == _selectedDate.year;
        }).toList();

        final totalOrders = filteredOrders.length;
        final activeOrders =
            filteredOrders.where((o) => o.status == 'active').length;
        final completedOrders =
            filteredOrders.where((o) => o.status == 'completed').length;

        // Hitung total pendapatan dari pesanan yang selesai
        final totalRevenue = filteredOrders
            .where((o) => o.status == 'completed' || o.status == 'active')
            .fold(0.0, (sum, order) => sum + order.totalPrice);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selector
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _selectDate();
                  },
                  borderRadius: BorderRadius.circular(8),
                  splashColor: AppColors.electricBlue.withValues(alpha: 0.2),
                  highlightColor: AppColors.electricBlue.withValues(alpha: 0.1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.electricBlue.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                color: AppColors.electricBlue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Periode: $_formattedPeriod',
                              style:
                                  const TextStyle(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: AppColors.electricBlue, size: 24),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Summary Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildSummaryCard(
                    'Total Pendapatan',
                    _formatCurrency(totalRevenue),
                    Icons.attach_money,
                    Colors.green,
                    '$completedOrders pesanan selesai',
                  ),
                  _buildSummaryCard(
                    'Total Pesanan',
                    '$totalOrders',
                    Icons.shopping_cart,
                    Colors.blue,
                    '$activeOrders aktif',
                  ),
                  _buildSummaryCard(
                    'Kendaraan Tersedia',
                    '$availableVehicles',
                    Icons.check_circle,
                    Colors.orange,
                    'dari $totalVehicles kendaraan',
                  ),
                  _buildSummaryCard(
                    'Sedang Disewa',
                    '$rentedVehicles',
                    Icons.directions_car,
                    Colors.purple,
                    'kendaraan aktif',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Transactions
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (orders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Belum ada transaksi',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...orders.take(5).map((order) => _buildTransactionItem(
                      'Booking #${order.id}',
                      '${order.vehicle.name}',
                      _formatCurrency(order.totalPrice),
                      _getStatusLabel(order.status),
                    )),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Widget _buildRevenueTab() {
    final orders = ref.watch(ordersProvider);

    // Filter orders berdasarkan bulan dan tahun yang dipilih
    final filteredOrders = orders.where((order) {
      return order.createdAt.month == _selectedDate.month &&
          order.createdAt.year == _selectedDate.year;
    }).toList();

    // Hitung total pendapatan
    final totalRevenue = filteredOrders
        .where((o) => o.status == 'completed' || o.status == 'active')
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    // Hitung pendapatan per kategori
    final mobilKeluargaRevenue = filteredOrders
        .where((o) =>
            (o.status == 'completed' || o.status == 'active') &&
            o.vehicle.category == VehicleCategory.mobilKeluarga)
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    final motorRevenue = filteredOrders
        .where((o) =>
            (o.status == 'completed' || o.status == 'active') &&
            o.vehicle.category == VehicleCategory.motor)
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    final mobilSportRevenue = filteredOrders
        .where((o) =>
            (o.status == 'completed' || o.status == 'active') &&
            o.vehicle.category == VehicleCategory.mobilSport)
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    final total = totalRevenue > 0 ? totalRevenue : 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _selectDate(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.electricBlue.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            color: AppColors.electricBlue, size: 20),
                        const SizedBox(width: 8),
                        Text('Periode: $_formattedPeriod',
                            style:
                                const TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.electricBlue, size: 24),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Total Revenue Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade700,
                  Colors.green.shade500,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pendapatan $_formattedPeriod',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatCurrency(totalRevenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.receipt_long,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${filteredOrders.length} transaksi',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Revenue by Category
          const Text(
            'Pendapatan per Kategori',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _buildCategoryRevenue('Mobil Keluarga', mobilKeluargaRevenue,
              mobilKeluargaRevenue / total, Colors.blue),
          _buildCategoryRevenue(
              'Motor', motorRevenue, motorRevenue / total, Colors.orange),
          _buildCategoryRevenue('Mobil Sport', mobilSportRevenue,
              mobilSportRevenue / total, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildVehicleTab() {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return vehiclesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (vehicles) {
        final totalVehicles = vehicles.length;
        final availableVehicles = vehicles.where((v) => v.isAvailable).length;
        final rentedVehicles = totalVehicles - availableVehicles;

        // Sort by rating for popular vehicles
        final sortedByRating = [...vehicles]
          ..sort((a, b) => b.rating.compareTo(a.rating));
        final popularVehicles = sortedByRating.take(5).toList();

        // Hitung utilisasi per kategori
        final mobilKeluarga = vehicles
            .where((v) => v.category == VehicleCategory.mobilKeluarga)
            .toList();
        final motor =
            vehicles.where((v) => v.category == VehicleCategory.motor).toList();
        final mobilSport = vehicles
            .where((v) => v.category == VehicleCategory.mobilSport)
            .toList();

        final mobilKeluargaUtilization = mobilKeluarga.isEmpty
            ? 0.0
            : mobilKeluarga.where((v) => !v.isAvailable).length /
                mobilKeluarga.length;
        final motorUtilization = motor.isEmpty
            ? 0.0
            : motor.where((v) => !v.isAvailable).length / motor.length;
        final mobilSportUtilization = mobilSport.isEmpty
            ? 0.0
            : mobilSport.where((v) => !v.isAvailable).length /
                mobilSport.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Stats
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard('Total', '$totalVehicles',
                        Icons.directions_car, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard('Tersedia', '$availableVehicles',
                        Icons.check_circle, Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard('Disewa', '$rentedVehicles',
                        Icons.timer, Colors.orange),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Popular Vehicles
              const Text(
                'Kendaraan Terpopuler',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (popularVehicles.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Belum ada kendaraan',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...popularVehicles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final vehicle = entry.value;
                  return _buildPopularVehicleItem(
                    vehicle.name,
                    '${vehicle.reviewCount} review',
                    vehicle.rating,
                    index + 1,
                  );
                }),

              const SizedBox(height: 24),

              // Vehicle Utilization
              const Text(
                'Tingkat Utilisasi Kendaraan',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildUtilizationBar('Mobil Keluarga (${mobilKeluarga.length})',
                  mobilKeluargaUtilization),
              _buildUtilizationBar('Motor (${motor.length})', motorUtilization),
              _buildUtilizationBar(
                  'Mobil Sport (${mobilSport.length})', mobilSportUtilization),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      String id, String description, String amount, String status) {
    Color statusColor;
    switch (status) {
      case 'Selesai':
        statusColor = Colors.green;
        break;
      case 'Aktif':
        statusColor = Colors.blue;
        break;
      case 'Dibatalkan':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.electricBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRevenue(
      String category, double amount, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatCurrency(amount),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage.isNaN ? 0 : percentage,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percentage.isNaN ? 0 : percentage * 100).toInt()}% dari total',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularVehicleItem(
      String name, String rentCount, double rating, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? Colors.amber.withValues(alpha: 0.2)
                  : AppColors.borderColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rank <= 3 ? Colors.amber : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  rentCount,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUtilizationBar(String category, double utilization) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              Text(
                '${(utilization * 100).toInt()}%',
                style: TextStyle(
                  color: utilization > 0.7 ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: utilization,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation(
                utilization > 0.7 ? Colors.green : Colors.orange,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
