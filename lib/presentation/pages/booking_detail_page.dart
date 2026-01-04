import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/cart_provider.dart';
import '../providers/date_range_provider.dart';
import '../widgets/date_range_picker_widget.dart';

class BookingPage extends ConsumerStatefulWidget {
  final VehicleEntity vehicle;

  const BookingPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final dateRange = ref.read(dateRangeProvider);
    _startDate = dateRange.startDate;
    _endDate = dateRange.endDate;

    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _confirmBooking() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi semua field yang diperlukan'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Add to cart
    final days = _endDate.difference(_startDate).inDays;
    final totalPrice =
        DateFormatter.calculateTotalPrice(widget.vehicle.pricePerDay, days);

    ref.read(cartProvider.notifier).addItem(
          vehicleId: widget.vehicle.id,
          vehicleName: widget.vehicle.name,
          startDate: _startDate,
          endDate: _endDate,
          pricePerDay: widget.vehicle.pricePerDay,
          totalPrice: totalPrice,
          customerName: _nameController.text,
          customerPhone: _phoneController.text,
          customerEmail: _emailController.text,
          notes: _noteController.text,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesanan ditambahkan ke keranjang!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final days = _endDate.difference(_startDate).inDays;
    final totalPrice =
        DateFormatter.calculateTotalPrice(widget.vehicle.pricePerDay, days);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Pesan Kendaraan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Summary
            Container(
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
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: widget.vehicle.imageUrl.startsWith('http')
                            ? Image.network(
                                widget.vehicle.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.directions_car,
                                color: AppColors.electricBlue,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vehicle.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              widget.vehicle.brand,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${widget.vehicle.pricePerDay.toStringAsFixed(0)}/hari',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.electricBlue,
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
            const SizedBox(height: 24),

            // Date Selection
            Text(
              'Tanggal Penyewaan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DateRangePickerWidget(
              initialStartDate: _startDate,
              initialEndDate: _endDate,
              onDateRangeSelected: (start, end) {
                setState(() {
                  _startDate = start;
                  _endDate = end;
                });
              },
            ),
            const SizedBox(height: 24),

            // Booking Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Harga/Hari',
                    'Rp ${widget.vehicle.pricePerDay.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Jumlah Hari',
                    '$days hari',
                  ),
                  const Divider(color: AppColors.borderColor),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Total Harga',
                    'Rp ${totalPrice.toStringAsFixed(0)}',
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Customer Information
            Text(
              'Informasi Penyewa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'No. Telepon',
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Catatan Khusus (Opsional)',
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Tambah ke Keranjang'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.electricBlue,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
