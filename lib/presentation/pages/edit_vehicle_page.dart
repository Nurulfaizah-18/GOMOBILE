import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/vehicle_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/vehicle_form_fields.dart';

class EditVehiclePage extends ConsumerStatefulWidget {
  final VehicleEntity vehicle;

  const EditVehiclePage({Key? key, required this.vehicle}) : super(key: key);

  @override
  ConsumerState<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends ConsumerState<EditVehiclePage> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _seatsController;
  late TextEditingController _pricePerDayController;
  late TextEditingController _licensePlateController;
  late TextEditingController _yearController;
  late TextEditingController _descriptionController;

  VehicleCategory? _selectedCategory;
  FuelType? _selectedFuelType;
  TransmissionType? _selectedTransmission;

  @override
  void initState() {
    super.initState();
    // Initialize controllers dengan data existing
    _nameController = TextEditingController(text: widget.vehicle.name);
    _brandController = TextEditingController(text: widget.vehicle.brand);
    _seatsController =
        TextEditingController(text: widget.vehicle.seats.toString());
    _pricePerDayController =
        TextEditingController(text: widget.vehicle.pricePerDay.toString());
    _licensePlateController =
        TextEditingController(text: widget.vehicle.licensePlate);
    _yearController =
        TextEditingController(text: widget.vehicle.year.toString());
    _descriptionController =
        TextEditingController(text: widget.vehicle.description);

    _selectedCategory = widget.vehicle.category;
    _selectedFuelType = widget.vehicle.fuelType;
    _selectedTransmission = widget.vehicle.transmission;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _seatsController.dispose();
    _pricePerDayController.dispose();
    _licensePlateController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_nameController.text.isEmpty ||
        _brandController.text.isEmpty ||
        _seatsController.text.isEmpty ||
        _pricePerDayController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedFuelType == null ||
        _selectedTransmission == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menyimpan perubahan...'),
          duration: Duration(seconds: 1),
        ),
      );

      final updatedVehicle = VehicleEntity(
        id: widget.vehicle.id,
        name: _nameController.text,
        brand: _brandController.text,
        category: _selectedCategory!,
        fuelType: _selectedFuelType!,
        transmission: _selectedTransmission!,
        seats: int.parse(_seatsController.text),
        imageUrl: widget.vehicle.imageUrl,
        pricePerDay: double.parse(_pricePerDayController.text),
        licensePlate: _licensePlateController.text.isEmpty
            ? 'B XXXX XXX'
            : _licensePlateController.text,
        year: _yearController.text.isEmpty
            ? 2024
            : int.parse(_yearController.text),
        rating: widget.vehicle.rating,
        reviewCount: widget.vehicle.reviewCount,
        isAvailable: widget.vehicle.isAvailable,
        description: _descriptionController.text,
      );

      await ref.read(vehiclesProvider.notifier).updateVehicle(updatedVehicle);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan berhasil diperbarui!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, updatedVehicle);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAdmin = authState.user?['role'] == 'admin';

    // Cek akses: hanya admin yang bisa mengakses halaman ini
    if (!isAdmin) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(
          backgroundColor: AppColors.darkBg,
          elevation: 0,
          title: const Text(
            'Akses Ditolak',
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'Akses Ditolak',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Halaman ini hanya untuk Admin',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Edit Kendaraan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Name Field
            VehicleFormFields.buildTextField(
              label: 'Nama Kendaraan',
              controller: _nameController,
              hintText: 'Contoh: Toyota Avanza',
            ),
            // Brand Field
            VehicleFormFields.buildTextField(
              label: 'Brand',
              controller: _brandController,
              hintText: 'Contoh: Toyota',
            ),
            // Category Dropdown
            VehicleFormFields.buildDropdownField<VehicleCategory>(
              label: 'Kategori',
              value: _selectedCategory,
              items: VehicleCategory.values,
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
              itemLabel: (category) => category.toString().split('.').last,
            ),
            // Fuel Type Dropdown
            VehicleFormFields.buildDropdownField<FuelType>(
              label: 'Jenis Bahan Bakar',
              value: _selectedFuelType,
              items: FuelType.values,
              onChanged: (value) {
                setState(() => _selectedFuelType = value);
              },
              itemLabel: (fuelType) => fuelType.toString().split('.').last,
            ),
            // Transmission Dropdown
            VehicleFormFields.buildDropdownField<TransmissionType>(
              label: 'Jenis Transmisi',
              value: _selectedTransmission,
              items: TransmissionType.values,
              onChanged: (value) {
                setState(() => _selectedTransmission = value);
              },
              itemLabel: (transmission) =>
                  transmission.toString().split('.').last,
            ),
            // Seats Field
            VehicleFormFields.buildNumberField(
              label: 'Jumlah Kursi',
              controller: _seatsController,
              hintText: 'Contoh: 7',
            ),
            // Price Field
            VehicleFormFields.buildNumberField(
              label: 'Harga per Hari (Rp)',
              controller: _pricePerDayController,
              hintText: 'Contoh: 300000',
            ),
            // License Plate Field
            VehicleFormFields.buildTextField(
              label: 'Plat Nomor',
              controller: _licensePlateController,
              hintText: 'Contoh: B 1234 ABC',
            ),
            // Year Field
            VehicleFormFields.buildNumberField(
              label: 'Tahun Kendaraan',
              controller: _yearController,
              hintText: 'Contoh: 2023',
            ),
            // Description Field
            VehicleFormFields.buildTextField(
              label: 'Deskripsi',
              controller: _descriptionController,
              hintText: 'Deskripsi kendaraan',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Perbarui'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
}
