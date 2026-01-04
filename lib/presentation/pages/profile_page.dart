import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/vehicle_provider.dart';
import '../providers/order_provider.dart';
import 'vehicle_management_page.dart';
import 'add_vehicle_page.dart';
import 'orders_page.dart';
import 'login_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';
import 'payment_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              AppColors.darkBg,
            ],
            stops: [0.0, 0.3, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Header with Logo
                    _buildHeader(),
                    const SizedBox(height: 30),

                    // Profile Card
                    _buildProfileCard(),
                    const SizedBox(height: 24),

                    // Quick Stats
                    _buildQuickStats(),
                    const SizedBox(height: 24),

                    // Menu Section
                    _buildMenuSection(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo Container with glow effect
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.electricBlue,
                AppColors.electricBlue.withValues(alpha: 0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricBlue.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_car,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'GOMOBILE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rental Kendaraan Terpercaya',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final authState = ref.watch(authProvider);
    final userName = authState.user?['name'] ?? 'User GOMOBILE';
    final userEmail = authState.user?['email'] ?? 'user@gomobile.com';
    final userRole = authState.user?['role'] ?? 'user';
    final isAdmin = userRole == 'admin';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.electricBlue.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with gradient border
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.electricBlue,
                    AppColors.success,
                  ],
                ),
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkSurface,
                ),
                child: const Icon(
                  Icons.person,
                  size: 35,
                  color: AppColors.electricBlue,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (userEmail.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isAdmin
                              ? Colors.orange.withValues(alpha: 0.2)
                              : AppColors.electricBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isAdmin ? '👑 ADMIN' : '👤 USER',
                          style: TextStyle(
                            fontSize: 10,
                            color: isAdmin
                                ? Colors.orange
                                : AppColors.electricBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '● Online',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.electricBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final orders = ref.watch(ordersProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.directions_car,
            value: vehiclesAsync.when(
              data: (vehicles) => '${vehicles.length}',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            label: 'Kendaraan',
            color: AppColors.electricBlue,
          ),
          const SizedBox(width: 12),
          _buildStatItem(
            icon: Icons.bookmark,
            value: '${orders.length}',
            label: 'Booking',
            color: AppColors.warning,
          ),
          const SizedBox(width: 12),
          _buildStatItem(
            icon: Icons.star,
            value: vehiclesAsync.when(
              data: (vehicles) {
                if (vehicles.isEmpty) return '0.0';
                final avgRating =
                    vehicles.map((v) => v.rating).reduce((a, b) => a + b) /
                        vehicles.length;
                return avgRating.toStringAsFixed(1);
              },
              loading: () => '...',
              error: (_, __) => '0.0',
            ),
            label: 'Rating',
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userRole = authState.user?['role'] ?? 'user';
    final isAdmin = userRole == 'admin';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAdmin ? 'Menu Admin' : 'Menu Utama',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Menu Grid - berbeda untuk Admin dan User
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: isAdmin
                ? _buildAdminMenuItems(context)
                : _buildUserMenuItems(context),
          ),

          const SizedBox(height: 20),

          // Logout Button
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.darkCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Apakah Anda yakin ingin keluar?',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Batal',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx); // Tutup dialog
                        ref.read(authProvider.notifier).logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Ya, Logout',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
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

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu items khusus untuk ADMIN
  /// Admin bisa: Kelola kendaraan, Tambah kendaraan, Cek pembayaran, Cek transaksi
  List<Widget> _buildAdminMenuItems(BuildContext context) {
    return [
      _buildMenuCard(
        icon: Icons.dashboard_outlined,
        title: 'Dashboard',
        subtitle: 'Lihat ringkasan',
        color: AppColors.electricBlue,
        onTap: () => Navigator.pushNamed(context, '/'),
      ),
      _buildMenuCard(
        icon: Icons.car_rental,
        title: 'Kelola',
        subtitle: 'Kendaraan',
        color: AppColors.accentBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VehicleManagementPage()),
        ),
      ),
      _buildMenuCard(
        icon: Icons.add_circle_outline,
        title: 'Tambah',
        subtitle: 'Kendaraan baru',
        color: AppColors.success,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddVehiclePage()),
        ),
      ),
      _buildMenuCard(
        icon: Icons.receipt_long_outlined,
        title: 'Kelola Pesanan',
        subtitle: 'Cek transaksi user',
        color: AppColors.warning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersPage()),
        ),
      ),
      _buildMenuCard(
        icon: Icons.payment_outlined,
        title: 'Pembayaran',
        subtitle: 'Cek pembayaran',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentPage()),
        ),
      ),
    ];
  }

  /// Menu items khusus untuk USER
  /// User bisa: Sewa kendaraan, Favorit, Pesanan, Pembayaran
  /// User TIDAK bisa: Kelola kendaraan, Tambah kendaraan
  List<Widget> _buildUserMenuItems(BuildContext context) {
    return [
      _buildMenuCard(
        icon: Icons.search_outlined,
        title: 'Cari',
        subtitle: 'Sewa kendaraan',
        color: AppColors.electricBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchPage()),
        ),
      ),
      _buildMenuCard(
        icon: Icons.favorite_outline,
        title: 'Favorit',
        subtitle: 'Kendaraan favorit',
        color: AppColors.error,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesPage()),
        ),
      ),
      _buildMenuCard(
        icon: Icons.receipt_long_outlined,
        title: 'Pesanan',
        subtitle: 'Riwayat sewa',
        color: AppColors.warning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersPage()),
        ),
      ),
    ];
  }
}
