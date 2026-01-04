import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

// Provider untuk data pengguna - mulai dengan data kosong
final usersProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

/// Halaman Kelola Pengguna untuk Admin
class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        title: const Text(
          'Kelola Pengguna',
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
      ),
      body: Column(
        children: [
          // Stats Summary
          _buildStatsSummary(users),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cari pengguna...',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.electricBlue),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.electricBlue, width: 2),
                ),
              ),
            ),
          ),

          // User List
          Expanded(
            child: users.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildUserCard(context, user);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: AppColors.electricBlue.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Pengguna',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pengguna yang mendaftar akan muncul di sini',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(List<Map<String, dynamic>> users) {
    final totalUsers = users.length;
    final activeUsers = users.where((u) => u['status'] == 'active').length;
    final inactiveUsers = users.where((u) => u['status'] == 'inactive').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.electricBlue.withValues(alpha: 0.8),
            AppColors.electricBlue.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', totalUsers.toString(), Icons.people),
          _buildStatItem('Aktif', activeUsers.toString(), Icons.check_circle),
          _buildStatItem('Nonaktif', inactiveUsers.toString(), Icons.cancel),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    final isActive = user['status'] == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    user['name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.electricBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user['name'],
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isActive ? 'Aktif' : 'Nonaktif',
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Button
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                color: AppColors.darkCard,
                onSelected: (value) {
                  _handleUserAction(context, value, user);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility,
                            color: AppColors.electricBlue, size: 20),
                        SizedBox(width: 8),
                        Text('Lihat Detail',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle_status',
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.block : Icons.check_circle,
                          color: isActive ? Colors.red : Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isActive ? 'Nonaktifkan' : 'Aktifkan',
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 8),

          // Additional Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(Icons.phone, user['phone']),
              _buildInfoChip(
                  Icons.calendar_today, 'Gabung: ${user['joinDate']}'),
              _buildInfoChip(
                  Icons.shopping_cart, '${user['totalBookings']} booking'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _handleUserAction(
      BuildContext context, String action, Map<String, dynamic> user) {
    switch (action) {
      case 'view':
        _showUserDetailDialog(context, user);
        break;
      case 'toggle_status':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status pengguna ${user['name']} berhasil diubah'),
            backgroundColor: AppColors.success,
          ),
        );
        break;
    }
  }

  void _showUserDetailDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          'Detail Pengguna',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nama', user['name']),
            _buildDetailRow('Email', user['email']),
            _buildDetailRow('Telepon', user['phone']),
            _buildDetailRow(
                'Status', user['status'] == 'active' ? 'Aktif' : 'Nonaktif'),
            _buildDetailRow('Tanggal Gabung', user['joinDate']),
            _buildDetailRow('Total Booking', '${user['totalBookings']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup',
                style: TextStyle(color: AppColors.electricBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              ': $value',
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
