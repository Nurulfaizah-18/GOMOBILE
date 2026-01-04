import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import 'user_dashboard_page.dart';
import 'admin_dashboard_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'vehicle_management_page.dart';
import 'orders_page.dart';
import 'favorites_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAdmin = authState.user?['role'] == 'admin';

    // Pages berbeda untuk admin dan user
    // User: Beranda, Cari, Favorit, Pesanan, Profil
    final List<Widget> userPages = [
      const UserDashboardPage(),
      const SearchPage(),
      const FavoritesPage(),
      const OrdersPage(),
      const ProfilePage(),
    ];

    // Admin: Dashboard, Kendaraan, Pesanan, Profil
    final List<Widget> adminPages = [
      const AdminDashboardPage(),
      const VehicleManagementPage(),
      const OrdersPage(),
      const ProfilePage(),
    ];

    final pages = isAdmin ? adminPages : userPages;

    // Navigation items berbeda untuk admin dan user
    final List<GButton> userTabs = [
      const GButton(
        icon: Icons.home_outlined,
        text: 'Beranda',
      ),
      const GButton(
        icon: Icons.search_outlined,
        text: 'Cari',
      ),
      const GButton(
        icon: Icons.favorite_outline,
        text: 'Favorit',
      ),
      const GButton(
        icon: Icons.history,
        text: 'Pesanan',
      ),
      const GButton(
        icon: Icons.person_outline,
        text: 'Profil',
      ),
    ];

    final List<GButton> adminTabs = [
      const GButton(
        icon: Icons.dashboard_outlined,
        text: 'Dashboard',
      ),
      const GButton(
        icon: Icons.directions_car_outlined,
        text: 'Kendaraan',
      ),
      const GButton(
        icon: Icons.list_alt_outlined,
        text: 'Kelola',
      ),
      const GButton(
        icon: Icons.person_outline,
        text: 'Profil',
      ),
    ];

    final tabs = isAdmin ? adminTabs : userTabs;

    // Reset index jika melebihi jumlah pages
    if (_selectedIndex >= pages.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: AppColors.electricBlue.withValues(alpha: 0.2),
              hoverColor: AppColors.electricBlue.withValues(alpha: 0.2),
              gap: 8,
              activeColor: isAdmin ? Colors.orange : AppColors.electricBlue,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.darkCard,
              color: AppColors.textSecondary,
              backgroundColor: AppColors.darkSurface,
              tabs: tabs,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
