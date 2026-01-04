import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/auth_provider.dart';

// Payment Status Enum
enum PaymentStatus { pending, processing, completed, failed, cancelled }

// Payment Method Enum
enum PaymentMethod { cash, transfer, ewallet, credit }

// Payment Entity
class PaymentEntity {
  final String id;
  final String orderId;
  final String vehicleName;
  final double amount;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? transactionId;

  PaymentEntity({
    required this.id,
    required this.orderId,
    required this.vehicleName,
    required this.amount,
    required this.status,
    required this.method,
    required this.createdAt,
    this.paidAt,
    this.transactionId,
  });
}

// Payment Provider
final paymentsProvider =
    StateNotifierProvider<PaymentsNotifier, List<PaymentEntity>>((ref) {
  return PaymentsNotifier();
});

class PaymentsNotifier extends StateNotifier<List<PaymentEntity>> {
  PaymentsNotifier() : super(_generateMockPayments());

  static List<PaymentEntity> _generateMockPayments() {
    return [
      PaymentEntity(
        id: 'PAY001',
        orderId: 'ORD001',
        vehicleName: 'Honda Brio RS',
        amount: 1200000,
        status: PaymentStatus.pending,
        method: PaymentMethod.transfer,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PaymentEntity(
        id: 'PAY002',
        orderId: 'ORD002',
        vehicleName: 'Toyota Avanza',
        amount: 1800000,
        status: PaymentStatus.completed,
        method: PaymentMethod.ewallet,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        paidAt: DateTime.now().subtract(const Duration(days: 1)),
        transactionId: 'TRX123456789',
      ),
      PaymentEntity(
        id: 'PAY003',
        orderId: 'ORD003',
        vehicleName: 'Mitsubishi Xpander',
        amount: 2400000,
        status: PaymentStatus.completed,
        method: PaymentMethod.transfer,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        paidAt: DateTime.now().subtract(const Duration(days: 3)),
        transactionId: 'TRX987654321',
      ),
      PaymentEntity(
        id: 'PAY004',
        orderId: 'ORD004',
        vehicleName: 'Suzuki Ertiga',
        amount: 1500000,
        status: PaymentStatus.failed,
        method: PaymentMethod.credit,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PaymentEntity(
        id: 'PAY005',
        orderId: 'ORD005',
        vehicleName: 'Daihatsu Xenia',
        amount: 1350000,
        status: PaymentStatus.processing,
        method: PaymentMethod.ewallet,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  void addPayment(PaymentEntity payment) {
    state = [...state, payment];
  }

  void updatePaymentStatus(String paymentId, PaymentStatus newStatus) {
    state = state.map((payment) {
      if (payment.id == paymentId) {
        return PaymentEntity(
          id: payment.id,
          orderId: payment.orderId,
          vehicleName: payment.vehicleName,
          amount: payment.amount,
          status: newStatus,
          method: payment.method,
          createdAt: payment.createdAt,
          paidAt: newStatus == PaymentStatus.completed ? DateTime.now() : null,
          transactionId: payment.transactionId,
        );
      }
      return payment;
    }).toList();
  }
}

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

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

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentsProvider);
    final authState = ref.watch(authProvider);
    final isAdmin = authState.user?['role'] == 'admin';

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        title: Text(
          isAdmin ? 'Kelola Pembayaran' : 'Status Pembayaran',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.electricBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.electricBlue),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.electricBlue,
          labelColor: AppColors.electricBlue,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Pending'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Info banner for user role
          if (!isAdmin) _buildUserInfoBanner(),

          // Summary Cards
          _buildSummarySection(payments, isAdmin),

          // Payment List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaymentList(payments, isAdmin),
                _buildPaymentList(
                    payments
                        .where((p) =>
                            p.status == PaymentStatus.pending ||
                            p.status == PaymentStatus.processing)
                        .toList(),
                    isAdmin),
                _buildPaymentList(
                    payments
                        .where((p) => p.status == PaymentStatus.completed)
                        .toList(),
                    isAdmin),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.electricBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.electricBlue.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.electricBlue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pantau status pembayaran rental kendaraan Anda di sini',
              style: TextStyle(
                color: AppColors.electricBlue,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(List<PaymentEntity> payments, bool isAdmin) {
    final totalPending = payments
        .where((p) =>
            p.status == PaymentStatus.pending ||
            p.status == PaymentStatus.processing)
        .fold(0.0, (sum, p) => sum + p.amount);

    final totalCompleted = payments
        .where((p) => p.status == PaymentStatus.completed)
        .fold(0.0, (sum, p) => sum + p.amount);

    final pendingCount = payments
        .where((p) =>
            p.status == PaymentStatus.pending ||
            p.status == PaymentStatus.processing)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Belum Dibayar',
              amount: totalPending,
              count: pendingCount,
              color: AppColors.warning,
              icon: Icons.pending_actions,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Dibayar',
              amount: totalCompleted,
              count: payments
                  .where((p) => p.status == PaymentStatus.completed)
                  .length,
              color: AppColors.success,
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            AppColors.darkCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            DateFormatter.formatPrice(amount),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count transaksi',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList(List<PaymentEntity> payments, bool isAdmin) {
    if (payments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: AppColors.borderColor,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada pembayaran',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        return _buildPaymentCard(payments[index], isAdmin);
      },
    );
  }

  Widget _buildPaymentCard(PaymentEntity payment, bool isAdmin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPaymentDetail(payment),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.vehicleName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Order: ${payment.orderId}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(payment.status),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderColor, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getPaymentMethodIcon(payment.method),
                          color: AppColors.electricBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPaymentMethodName(payment.method),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormatter.formatPrice(payment.amount),
                      style: const TextStyle(
                        color: AppColors.electricBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDateTime(payment.createdAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    // Admin: Tombol konfirmasi/update pembayaran
                    // User: Hanya lihat status
                    if (isAdmin &&
                        (payment.status == PaymentStatus.pending ||
                            payment.status == PaymentStatus.processing))
                      GestureDetector(
                        onTap: () => _showAdminPaymentActions(payment),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    AppColors.success.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            'Konfirmasi',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else if (!isAdmin &&
                        (payment.status == PaymentStatus.pending ||
                            payment.status == PaymentStatus.processing))
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          'Menunggu Konfirmasi',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else if (payment.status == PaymentStatus.completed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                color: AppColors.success, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Lunas',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (payment.status == PaymentStatus.failed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel,
                                color: AppColors.error, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Gagal',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAdminPaymentActions(PaymentEntity payment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Konfirmasi Pembayaran',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order: ${payment.orderId} - ${payment.vehicleName}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            Text(
              'Jumlah: ${DateFormatter.formatPrice(payment.amount)}',
              style: const TextStyle(
                color: AppColors.electricBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(paymentsProvider.notifier).updatePaymentStatus(
                            payment.id,
                            PaymentStatus.completed,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pembayaran dikonfirmasi!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Konfirmasi Lunas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(paymentsProvider.notifier).updatePaymentStatus(
                            payment.id,
                            PaymentStatus.failed,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pembayaran ditolak'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Tolak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PaymentStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case PaymentStatus.pending:
        color = AppColors.warning;
        text = 'Menunggu';
        icon = Icons.access_time;
        break;
      case PaymentStatus.processing:
        color = Colors.blue;
        text = 'Diproses';
        icon = Icons.sync;
        break;
      case PaymentStatus.completed:
        color = AppColors.success;
        text = 'Selesai';
        icon = Icons.check_circle;
        break;
      case PaymentStatus.failed:
        color = AppColors.error;
        text = 'Gagal';
        icon = Icons.error;
        break;
      case PaymentStatus.cancelled:
        color = AppColors.textSecondary;
        text = 'Dibatalkan';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.payments;
      case PaymentMethod.transfer:
        return Icons.account_balance;
      case PaymentMethod.ewallet:
        return Icons.wallet;
      case PaymentMethod.credit:
        return Icons.credit_card;
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Tunai';
      case PaymentMethod.transfer:
        return 'Transfer Bank';
      case PaymentMethod.ewallet:
        return 'E-Wallet';
      case PaymentMethod.credit:
        return 'Kartu Kredit';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return DateFormatter.formatDate(dateTime);
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Filter Pembayaran',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip('Semua', 'all', setState),
                      _buildFilterChip('Transfer', 'transfer', setState),
                      _buildFilterChip('E-Wallet', 'ewallet', setState),
                      _buildFilterChip('Tunai', 'cash', setState),
                      _buildFilterChip('Kartu Kredit', 'credit', setState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricBlue,
                      ),
                      child: const Text('Terapkan Filter'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(
      String label, String value, StateSetter setModalState) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _selectedFilter = value;
        });
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.electricBlue
              : AppColors.electricBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.electricBlue
                : AppColors.electricBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.electricBlue,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showPaymentDetail(PaymentEntity payment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detail Pembayaran',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusBadge(payment.status),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Payment Info
                  _buildDetailItem('ID Pembayaran', payment.id),
                  _buildDetailItem('ID Order', payment.orderId),
                  _buildDetailItem('Kendaraan', payment.vehicleName),
                  _buildDetailItem(
                      'Metode', _getPaymentMethodName(payment.method)),
                  _buildDetailItem('Tanggal Dibuat',
                      DateFormatter.formatDate(payment.createdAt)),
                  if (payment.paidAt != null)
                    _buildDetailItem('Tanggal Bayar',
                        DateFormatter.formatDate(payment.paidAt!)),
                  if (payment.transactionId != null)
                    _buildDetailItem('ID Transaksi', payment.transactionId!),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.borderColor),
                  const SizedBox(height: 16),

                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormatter.formatPrice(payment.amount),
                        style: const TextStyle(
                          color: AppColors.electricBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  if (payment.status == PaymentStatus.pending ||
                      payment.status == PaymentStatus.processing) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showPayNowDialog(payment);
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text('Bayar Sekarang'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Batalkan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ] else if (payment.status == PaymentStatus.completed) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Download invoice logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invoice sedang diunduh...'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Invoice'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.electricBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showPayNowDialog(PaymentEntity payment) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedMethod = 'transfer';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.darkCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total: ${DateFormatter.formatPrice(payment.amount)}',
                    style: const TextStyle(
                      color: AppColors.electricBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPaymentMethodOption(
                    'Transfer Bank',
                    'BCA, Mandiri, BNI',
                    Icons.account_balance,
                    'transfer',
                    selectedMethod,
                    (value) => setState(() => selectedMethod = value),
                  ),
                  _buildPaymentMethodOption(
                    'E-Wallet',
                    'GoPay, OVO, Dana',
                    Icons.wallet,
                    'ewallet',
                    selectedMethod,
                    (value) => setState(() => selectedMethod = value),
                  ),
                  _buildPaymentMethodOption(
                    'Kartu Kredit',
                    'Visa, Mastercard',
                    Icons.credit_card,
                    'credit',
                    selectedMethod,
                    (value) => setState(() => selectedMethod = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processPayment(payment, selectedMethod);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('Bayar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentMethodOption(
    String title,
    String subtitle,
    IconData icon,
    String value,
    String groupValue,
    Function(String) onChanged,
  ) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.electricBlue.withValues(alpha: 0.15)
              : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.electricBlue : AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected ? AppColors.electricBlue : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.electricBlue),
          ],
        ),
      ),
    );
  }

  void _processPayment(PaymentEntity payment, String method) {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.electricBlue),
            SizedBox(height: 16),
            Text(
              'Memproses pembayaran...',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );

    // Simulate payment process
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      // Update payment status
      ref
          .read(paymentsProvider.notifier)
          .updatePaymentStatus(payment.id, PaymentStatus.completed);

      // Show success dialog
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pembayaran ${DateFormatter.formatPrice(payment.amount)} telah berhasil diproses.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
