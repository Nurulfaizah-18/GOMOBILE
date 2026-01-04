import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/vehicle_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/vehicle_form_fields.dart';

class AddVehiclePage extends ConsumerStatefulWidget {
  const AddVehiclePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends ConsumerState<AddVehiclePage> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _seatsController;
  late TextEditingController _imageUrlController;
  late TextEditingController _pricePerDayController;
  late TextEditingController _licensePlateController;
  late TextEditingController _yearController;
  late TextEditingController _descriptionController;

  VehicleCategory? _selectedCategory;
  FuelType? _selectedFuelType;
  TransmissionType? _selectedTransmission;

  XFile? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Gagal memilih gambar - $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (photo != null) {
        setState(() {
          _selectedImage = photo;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Gagal mengambil foto - $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _brandController = TextEditingController();
    _seatsController = TextEditingController();
    _imageUrlController = TextEditingController();
    _pricePerDayController = TextEditingController();
    _licensePlateController = TextEditingController();
    _yearController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _seatsController.dispose();
    _imageUrlController.dispose();
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
      // Show loading indicator
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menyimpan kendaraan...'),
          duration: Duration(seconds: 1),
        ),
      );

      final newVehicle = VehicleEntity(
        id: _idController.text.isEmpty
            ? DateTime.now().millisecondsSinceEpoch.toString()
            : _idController.text,
        name: _nameController.text,
        brand: _brandController.text,
        category: _selectedCategory!,
        fuelType: _selectedFuelType!,
        transmission: _selectedTransmission!,
        seats: int.parse(_seatsController.text),
        imageUrl: _selectedImage != null
            ? _selectedImage!.path
            : (_imageUrlController.text.isEmpty
                ? 'https://via.placeholder.com/400x300?text=Vehicle'
                : _imageUrlController.text),
        pricePerDay: double.parse(_pricePerDayController.text),
        licensePlate: _licensePlateController.text.isEmpty
            ? 'B XXXX XXX'
            : _licensePlateController.text,
        year: _yearController.text.isEmpty
            ? 2024
            : int.parse(_yearController.text),
        rating: 0,
        reviewCount: 0,
        isAvailable: true,
        description: _descriptionController.text,
      );

      // Await the save operation
      await ref.read(vehiclesProvider.notifier).addVehicle(newVehicle);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan berhasil disimpan!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // Clear form
      _idController.clear();
      _nameController.clear();
      _brandController.clear();
      _seatsController.clear();
      _imageUrlController.clear();
      _pricePerDayController.clear();
      _licensePlateController.clear();
      _yearController.clear();
      _descriptionController.clear();

      setState(() {
        _selectedCategory = null;
        _selectedFuelType = null;
        _selectedTransmission = null;
        _selectedImage = null;
      });

      Navigator.pop(context);
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

  Widget _buildImagePickerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Foto Kendaraan*',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 12),

          // Image Preview
          if (_selectedImage != null)
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.darkSurface,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (!kIsWeb)
                    Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: AppColors.darkSurface,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 48,
                            color: AppColors.success,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Foto terpilih: ${_selectedImage!.name}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: AppColors.electricBlue.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada foto yang dipilih',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pilih dari Galeri'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Ambil Foto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              const Icon(Icons.lock_outline, size: 80, color: AppColors.error),
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
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        title: const Text(
          'Tambah Kendaraan',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker Section
            _buildImagePickerSection(),

            const SizedBox(height: 16),

            // ID (optional)
            VehicleFormFields.buildTextField(
              label: 'ID Kendaraan (Optional)',
              controller: _idController,
              hintText: 'Biarkan kosong untuk auto-generate',
            ),

            // Name
            VehicleFormFields.buildTextField(
              label: 'Nama Kendaraan*',
              controller: _nameController,
              hintText: 'Contoh: Honda CR-V 1.5L',
            ),

            // Brand
            VehicleFormFields.buildTextField(
              label: 'Brand*',
              controller: _brandController,
              hintText: 'Contoh: Honda',
            ),

            // Category
            VehicleFormFields.buildDropdownField<VehicleCategory>(
              label: 'Kategori Kendaraan*',
              value: _selectedCategory,
              items: VehicleCategory.values,
              itemLabel: (cat) => cat.name,
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),

            // Fuel Type
            VehicleFormFields.buildDropdownField<FuelType>(
              label: 'Tipe Bahan Bakar*',
              value: _selectedFuelType,
              items: FuelType.values,
              itemLabel: (fuel) => fuel.name,
              onChanged: (value) => setState(() => _selectedFuelType = value),
            ),

            // Transmission
            VehicleFormFields.buildDropdownField<TransmissionType>(
              label: 'Transmisi*',
              value: _selectedTransmission,
              items: TransmissionType.values,
              itemLabel: (trans) => trans.name,
              onChanged: (value) =>
                  setState(() => _selectedTransmission = value),
            ),

            // Seats
            VehicleFormFields.buildNumberField(
              label: 'Jumlah Kursi*',
              controller: _seatsController,
              hintText: 'Contoh: 5',
            ),

            // Image URL
            VehicleFormFields.buildTextField(
              label: 'URL Gambar (Fallback jika tidak upload foto)',
              controller: _imageUrlController,
              hintText: 'https://example.com/image.jpg',
            ),

            // Price per Day
            VehicleFormFields.buildNumberField(
              label: 'Harga per Hari (Rp)*',
              controller: _pricePerDayController,
              hintText: 'Contoh: 500000',
            ),

            // License Plate
            VehicleFormFields.buildTextField(
              label: 'Plat Nomor (Optional)',
              controller: _licensePlateController,
              hintText: 'Contoh: B 1234 ABC',
            ),

            // Year
            VehicleFormFields.buildNumberField(
              label: 'Tahun Kendaraan (Optional)',
              controller: _yearController,
              hintText: 'Contoh: 2024',
            ),

            // Description
            VehicleFormFields.buildTextField(
              label: 'Deskripsi',
              controller: _descriptionController,
              hintText: 'Deskripsi singkat tentang kendaraan...',
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tambah Kendaraan',
                  style: TextStyle(
                    color: AppColors.darkBg,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.electricBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: AppColors.electricBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
