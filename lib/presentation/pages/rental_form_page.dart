import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/order_provider.dart';

class RentalFormPage extends ConsumerStatefulWidget {
  final VehicleEntity vehicle;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const RentalFormPage({
    Key? key,
    required this.vehicle,
    this.initialStartDate,
    this.initialEndDate,
  }) : super(key: key);

  @override
  ConsumerState<RentalFormPage> createState() => _RentalFormPageState();
}

class _RentalFormPageState extends ConsumerState<RentalFormPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _startDate;
  late DateTime _endDate;

  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ktpController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  // Rental options
  String _rentalType = 'self_drive'; // self_drive / with_driver
  String _pickupLocation = 'office'; // office / delivery
  String _paymentMethod = 'cash';
  bool _agreeTerms = false;
  bool _isLoading = false;

  // Pricing
  final double _driverFeePerDay = 150000;
  final double _deliveryFee = 50000;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate ?? DateTime.now();
    _endDate =
        widget.initialEndDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ktpController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int get _rentalDays => _endDate.difference(_startDate).inDays;

  double get _basePrice => widget.vehicle.pricePerDay * _rentalDays;

  double get _driverFee =>
      _rentalType == 'with_driver' ? _driverFeePerDay * _rentalDays : 0;

  double get _deliveryFeeTotal =>
      _pickupLocation == 'delivery' ? _deliveryFee : 0;

  double get _totalPrice => _basePrice + _driverFee + _deliveryFeeTotal;

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat dan ketentuan'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(ordersProvider.notifier).createOrder(
            widget.vehicle.id,
            _startDate,
            _endDate,
          );

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat pesanan: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
            Text(
              'Pesanan Berhasil!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan sewa ${widget.vehicle.name} telah berhasil dibuat. Silakan cek halaman pesanan untuk detail.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Back to previous page
                  Navigator.pop(context); // Back to vehicle list
                },
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        title: const Text(
          'Form Sewa Kendaraan',
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Info Card
              _buildVehicleCard(),

              const SizedBox(height: 24),

              // Rental Period
              _buildSectionTitle('Periode Sewa', Icons.calendar_month),
              const SizedBox(height: 12),
              _buildDateSelector(),

              const SizedBox(height: 24),

              // Rental Type
              _buildSectionTitle('Jenis Sewa', Icons.car_rental),
              const SizedBox(height: 12),
              _buildRentalTypeSelector(),

              const SizedBox(height: 24),

              // Pickup Location
              _buildSectionTitle('Lokasi Pengambilan', Icons.location_on),
              const SizedBox(height: 12),
              _buildPickupLocationSelector(),

              const SizedBox(height: 24),

              // Customer Data
              _buildSectionTitle('Data Penyewa', Icons.person),
              const SizedBox(height: 12),
              _buildCustomerForm(),

              const SizedBox(height: 24),

              // Payment Method
              _buildSectionTitle('Metode Pembayaran', Icons.payment),
              const SizedBox(height: 12),
              _buildPaymentMethodSelector(),

              const SizedBox(height: 24),

              // Notes
              _buildSectionTitle('Catatan Tambahan', Icons.note),
              const SizedBox(height: 12),
              _buildNoteField(),

              const SizedBox(height: 24),

              // Terms & Conditions
              _buildTermsCheckbox(),

              const SizedBox(height: 24),

              // Price Summary
              _buildPriceSummary(),

              const SizedBox(height: 24),

              // Submit Button
              _buildSubmitButton(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.electricBlue, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.electricBlue.withValues(alpha: 0.2),
            AppColors.darkCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.electricBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.darkSurface,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.vehicle.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.directions_car,
                  color: AppColors.electricBlue,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicle.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.vehicle.brand,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${DateFormatter.formatPrice(widget.vehicle.pricePerDay)}/hari',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateItem(
                  'Tanggal Mulai',
                  _startDate,
                  () => _selectDate(isStart: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.electricBlue,
                ),
              ),
              Expanded(
                child: _buildDateItem(
                  'Tanggal Selesai',
                  _endDate,
                  () => _selectDate(isStart: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.electricBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer,
                    color: AppColors.electricBlue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Durasi: $_rentalDays hari',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.electricBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String label, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatDate(date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final initialDate = isStart ? _startDate : _endDate;
    final firstDate = isStart ? DateTime.now() : _startDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.electricBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildRentalTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildOptionTile(
            title: 'Lepas Kunci (Self Drive)',
            subtitle: 'Anda menyetir sendiri',
            icon: Icons.key,
            value: 'self_drive',
            groupValue: _rentalType,
            onChanged: (value) => setState(() => _rentalType = value!),
          ),
          Divider(color: AppColors.borderColor, height: 1),
          _buildOptionTile(
            title: 'Dengan Supir',
            subtitle: '+${DateFormatter.formatPrice(_driverFeePerDay)}/hari',
            icon: Icons.person,
            value: 'with_driver',
            groupValue: _rentalType,
            onChanged: (value) => setState(() => _rentalType = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupLocationSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildOptionTile(
            title: 'Ambil di Kantor',
            subtitle: 'Jl. Raya Utama No. 123, Jakarta',
            icon: Icons.store,
            value: 'office',
            groupValue: _pickupLocation,
            onChanged: (value) => setState(() => _pickupLocation = value!),
          ),
          Divider(color: AppColors.borderColor, height: 1),
          _buildOptionTile(
            title: 'Antar ke Lokasi',
            subtitle:
                '+${DateFormatter.formatPrice(_deliveryFee)} (sekali antar)',
            icon: Icons.local_shipping,
            value: 'delivery',
            groupValue: _pickupLocation,
            onChanged: (value) => setState(() => _pickupLocation = value!),
          ),
          if (_pickupLocation == 'delivery') ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                decoration: _inputDecoration(
                  'Alamat Pengantaran',
                  'Masukkan alamat lengkap',
                  Icons.location_on,
                ),
                validator: (value) {
                  if (_pickupLocation == 'delivery' &&
                      (value == null || value.isEmpty)) {
                    return 'Alamat pengantaran wajib diisi';
                  }
                  return null;
                },
                maxLines: 2,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value == groupValue;
    // ignore: deprecated_member_use
    return RadioListTile<String>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // ignore: deprecated_member_use
      onChanged: onChanged,
      activeColor: AppColors.electricBlue,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.electricBlue.withValues(alpha: 0.2)
                  : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color:
                  isSelected ? AppColors.electricBlue : AppColors.textSecondary,
              size: 20,
            ),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration(
                'Nama Lengkap*', 'Masukkan nama sesuai KTP', Icons.person),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ktpController,
            decoration: _inputDecoration(
                'No. KTP/SIM*', 'Masukkan 16 digit', Icons.badge),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'No. KTP wajib diisi';
              if (value!.length < 16) return 'No. KTP harus 16 digit';
              return null;
            },
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration:
                _inputDecoration('No. HP*', 'Contoh: 08123456789', Icons.phone),
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value?.isEmpty ?? true ? 'No. HP wajib diisi' : null,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration:
                _inputDecoration('Email*', 'contoh@email.com', Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Email wajib diisi';
              if (!value!.contains('@')) return 'Format email tidak valid';
              return null;
            },
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: _inputDecoration(
                'Alamat Lengkap*', 'Masukkan alamat domisili', Icons.home),
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Alamat wajib diisi' : null,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle:
          TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
      prefixIcon: Icon(icon, color: AppColors.electricBlue, size: 20),
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.electricBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildPaymentOption('cash', 'Tunai', Icons.payments,
              'Bayar langsung saat pengambilan'),
          Divider(color: AppColors.borderColor, height: 1),
          _buildPaymentOption('transfer', 'Transfer Bank',
              Icons.account_balance, 'BCA, Mandiri, BNI, BRI'),
          Divider(color: AppColors.borderColor, height: 1),
          _buildPaymentOption('ewallet', 'E-Wallet', Icons.wallet,
              'GoPay, OVO, Dana, ShopeePay'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      String value, String title, IconData icon, String subtitle) {
    final isSelected = _paymentMethod == value;
    // ignore: deprecated_member_use
    return RadioListTile<String>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: _paymentMethod,
      // ignore: deprecated_member_use
      onChanged: (val) => setState(() => _paymentMethod = val!),
      activeColor: AppColors.electricBlue,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.electricBlue.withValues(alpha: 0.2)
                  : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color:
                  isSelected ? AppColors.electricBlue : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: _noteController,
        maxLines: 3,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Tambahkan catatan khusus jika ada...',
          hintStyle:
              TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text(
                'Syarat & Ketentuan',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Penyewa wajib memiliki SIM yang masih berlaku\n'
            '• Kendaraan harus dikembalikan dalam kondisi bersih\n'
            '• Keterlambatan pengembalian dikenakan denda\n'
            '• Kerusakan ditanggung oleh penyewa',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agreeTerms,
                  onChanged: (val) =>
                      setState(() => _agreeTerms = val ?? false),
                  activeColor: AppColors.electricBlue,
                  side: const BorderSide(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Saya menyetujui syarat dan ketentuan yang berlaku',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.electricBlue.withValues(alpha: 0.15),
            AppColors.darkCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.electricBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: AppColors.electricBlue),
              const SizedBox(width: 8),
              Text(
                'Rincian Harga',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Sewa Kendaraan',
            '${DateFormatter.formatPrice(widget.vehicle.pricePerDay)} x $_rentalDays hari',
            _basePrice,
          ),
          if (_driverFee > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Biaya Supir',
              '${DateFormatter.formatPrice(_driverFeePerDay)} x $_rentalDays hari',
              _driverFee,
            ),
          ],
          if (_deliveryFeeTotal > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Antar', 'Sekali antar', _deliveryFeeTotal),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                DateFormatter.formatPrice(_totalPrice),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.electricBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String detail, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        Text(
          DateFormatter.formatPrice(amount),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          disabledBackgroundColor: AppColors.borderColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Konfirmasi Sewa - ${DateFormatter.formatPrice(_totalPrice)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
