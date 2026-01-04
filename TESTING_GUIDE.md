# Panduan Testing Fitur Penyimpanan Kendaraan

## Masalah yang Sudah Diperbaiki ✅

1. **Error Import** - Dihapus import tidak perlu (shared_preferences dari provider)
2. **Type Error** - Dihapus casting yang tidak perlu
3. **Architecture** - Simplified flow tanpa local datasource yang rumit untuk sekarang

## Cara Menjalankan Aplikasi

### Step 1: Build dan Run
```bash
cd d:\Gomobile\rental_kendaraan
flutter clean
flutter pub get
flutter run
```

### Step 2: Navigasi ke Halaman Add Vehicle
1. Buka aplikasi (pastikan sudah run)
2. Klik tab **Profil** (icon person di bottom navigation)
3. Cari tombol atau opsi "Tambah Kendaraan" atau "Add Vehicle"
4. Tekan tombol tersebut

### Step 3: Isi Form Penyimpanan Kendaraan
Isi semua field berikut (ditandai dengan *):

**Field Wajib:**
- **ID Kendaraan** - Biarkan kosong atau isi custom ID
- **Nama Kendaraan*** - Contoh: "Toyota Avanza"
- **Brand*** - Contoh: "Toyota"
- **Kategori*** - Pilih dari dropdown (Mobil Keluarga, Mobil Sport, Mobil Mewah, Motor)
- **Tipe Bahan Bakar*** - Pilih dari dropdown (Bensin, Diesel, Hybrid, Listrik)
- **Transmisi*** - Pilih dari dropdown (Manual, Otomatis)
- **Jumlah Kursi*** - Contoh: "7"
- **Harga/Hari*** - Contoh: "150000"
- **Foto** - Ambil dari kamera/galeri (optional, akan pakai placeholder jika kosong)
- **Plat Nomor** - Contoh: "B 1234 XYZ" (optional)
- **Tahun** - Contoh: "2023" (optional)
- **Deskripsi** - Contoh: "Mobil nyaman untuk keluarga" (optional)

### Step 4: Submit Form
1. Klik tombol **"Simpan"** atau **"Save"**
2. Tunggu loading message "Menyimpan kendaraan..."
3. Tunggu success message "Kendaraan berhasil disimpan!"
4. Form akan ter-clear otomatis
5. Page akan menutup dan kembali ke profile/dashboard

### Step 5: Verifikasi Penyimpanan
1. Buka tab **Beranda** (Home)
2. Lihat apakah kendaraan baru muncul di dashboard/daftar kendaraan
3. Buka tab **Cari** untuk mencari kendaraan yang baru ditambahkan
4. Tekan kendaraan untuk melihat detail

## Apa yang Terjadi di Backend

Ketika Anda submit form:

```
AddVehiclePage._submitForm() (async)
    ↓
Create VehicleEntity dari input form
    ↓
ref.read(vehiclesProvider.notifier).addVehicle(vehicle)
    ↓
VehiclesNotifier.addVehicle() (async)
    ↓
await addVehicleUsecase(vehicle)
    ↓
AddVehicleUsecase.call(vehicle)
    ↓
repository.addVehicle(vehicle)
    ↓
VehicleRepositoryImpl.addVehicle()
    ↓
remoteDataSource.addVehicle(vehicleModel)
    ↓
VehicleRemoteDataSourceImpl.addVehicle()
    ↓
_vehicles.add(vehicleModel) // Menyimpan dalam list in-memory
    ↓
State di Riverpod di-update dengan kendaraan baru
    ↓
Success message ditampilkan
```

## Penyimpanan Data

**Lokasi Penyimpanan (Saat Ini):**
- In-memory list `_vehicles` di `VehicleRemoteDataSourceImpl`
- Data hilang ketika app di-restart (normal untuk tahap development)

**Plan Upgrade ke Persistent Storage:**
- Gunakan LocalDataSource dengan SharedPreferences untuk persistent storage
- Implementasi sudah siap di `VehicleLocalDataSourceImpl`
- Perlu di-integrate ke repository nanti

## Troubleshooting

### ❌ Form tidak submit
**Solusi:**
- Pastikan semua field dengan * sudah diisi
- Check console untuk error message
- Lihat SnackBar untuk feedback

### ❌ Kendaraan tidak muncul setelah submit
**Solusi:**
- Check apakah success message muncul
- Jika tidak ada message, check error in console
- Pastikan navigasi ke halaman lain untuk refresh data

### ❌ Error: "Semua field harus diisi!"
**Solusi:**
- Review field mana yang kosong (lihat form)
- Isi semua field yang ditandai dengan *

### ❌ App crash saat submit
**Solusi:**
- Check console untuk error stack trace
- Pastikan `VehicleEntity` dapat di-instantiate dengan data yang diberikan
- Verifikasi type data (int untuk seats dan year, double untuk price)

## File-file yang Terlibat

### Data Layer
- `lib/data/datasources/remote/vehicle_remote_datasource.dart` - Remote data source dengan addVehicle()
- `lib/data/datasources/local/vehicle_local_datasource.dart` - Local storage (ready tapi belum digunakan)
- `lib/data/repositories/vehicle_repository_impl.dart` - Repository dengan addVehicle()

### Domain Layer
- `lib/domain/repositories/vehicle_repository.dart` - Abstract repository interface
- `lib/domain/usecases/vehicle_usecases.dart` - AddVehicleUsecase

### Presentation Layer
- `lib/presentation/providers/vehicle_provider.dart` - Riverpod providers & VehiclesNotifier
- `lib/presentation/pages/add_vehicle_page.dart` - UI form & _submitForm() async method

## Next Steps (Future Enhancements)

1. **Persistent Storage** - Integrate LocalDataSource dengan SharedPreferences
2. **Image Upload** - Upload gambar ke storage/server
3. **Better Validation** - Validation lebih detail untuk setiap field
4. **API Integration** - Integrate dengan backend API (ganti mock data)
5. **Offline Sync** - Implement offline sync ketika ada koneksi

## Testing Checklist

- [ ] Form dapat dibuka
- [ ] Semua field terlihat
- [ ] Dapat memilih dropdown (Kategori, Fuel, Transmisi)
- [ ] Dapat upload/pilih foto
- [ ] Submit button clickable
- [ ] Loading message muncul
- [ ] Success message muncul
- [ ] Form ter-clear setelah submit
- [ ] Page menutup dan kembali
- [ ] Kendaraan muncul di dashboard
- [ ] Kendaraan dapat dicari dengan search

Jika ada yang masih tidak berfungsi, hubungi developer dengan detail error message dari console.
