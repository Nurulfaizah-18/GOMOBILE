# Rental Kendaraan - Flutter Application

Aplikasi Mobile untuk Rental Kendaraan (Mobil & Motor) dengan arsitektur Clean Architecture, modern UI dengan dark mode, dan fitur-fitur lengkap.

## 📋 Fitur Utama

- ✅ **Dashboard** - Menampilkan kategori dan kendaraan terpopuler
- ✅ **Detail Kendaraan** - Spesifikasi lengkap (transmisi, bahan bakar, kursi, dll)
- ✅ **Date Range Picker** - Pemilihan tanggal sewa yang fleksibel
- ✅ **Keranjang/Reservasi** - Kelola reservasi kendaraan
- ✅ **Sistem Pembayaran** - Mockup payment system
- ✅ **Search** - Pencarian kendaraan berdasarkan nama/merek
- ✅ **Profile** - Manajemen profil pengguna
- ✅ **Modern UI** - Dark mode dengan Electric Blue accent

## 🏗️ Struktur Project (Clean Architecture)

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/
│       └── date_formatter.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── vehicle_local_datasource.dart
│   │   └── remote/
│   │       └── vehicle_remote_datasource.dart
│   ├── models/
│   │   ├── vehicle_model.dart
│   │   └── vehicle_model.g.dart
│   └── repositories/
│       ├── vehicle_repository_impl.dart
│       └── order_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── vehicle_entity.dart
│   │   ├── rental_order_entity.dart
│   │   └── cart_item_entity.dart
│   ├── repositories/
│   │   ├── vehicle_repository.dart
│   │   └── order_repository.dart
│   └── usecases/
│       ├── vehicle_usecases.dart
│       └── order_usecases.dart
├── presentation/
│   ├── pages/
│   │   ├── main_page.dart
│   │   ├── dashboard_page.dart
│   │   ├── vehicle_detail_page.dart
│   │   ├── search_page.dart
│   │   ├── cart_page.dart
│   │   └── profile_page.dart
│   ├── providers/
│   │   ├── vehicle_provider.dart
│   │   ├── cart_provider.dart
│   │   └── date_range_provider.dart
│   └── widgets/
│       ├── vehicle_card.dart
│       ├── date_range_picker_widget.dart
│       ├── specification_item.dart
│       └── category_chip.dart
└── main.dart
```

## 🎨 Tema Design

### Warna Utama
- **Background**: Deep Grey (#0F1419)
- **Surface**: Dark Grey (#1A1F26)
- **Accent**: Electric Blue (#00D9FF)
- **Text Primary**: Light Grey (#F3F4F6)
- **Text Secondary**: Medium Grey (#9CA3AF)

### Typography
- **Font**: Poppins
- **Headings**: Bold (700)
- **Body**: Regular (400)
- **Accents**: Semi-Bold (600)

## 📦 Dependencies

```yaml
provider: ^6.0.0              # State Management
google_nav_bar: ^5.0.5        # Navigation Bar
flutter_riverpod: ^2.4.0      # Advanced State Management
intl: ^0.19.0                 # Localization & Formatting
json_annotation: ^4.8.0       # Model Serialization
equatable: ^2.0.5             # Value Equality
dartz: ^0.10.1                # Functional Programming
dio: ^5.3.0                   # HTTP Client
flutter_svg: ^2.0.5           # SVG Support
```

## 🚀 Setup & Running

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- Android Studio / Xcode

### Installation

1. **Clone Repository**
```bash
cd rental_kendaraan
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Generate Model Files**
```bash
flutter pub run build_runner build
```

4. **Run Application**
```bash
flutter run
```

## 📱 Pages & Screens

### 1. Dashboard Page
- Menampilkan kendaraan terpopuler
- Grid kategori kendaraan
- List semua kendaraan dengan rating
- Pull-to-refresh functionality

### 2. Vehicle Detail Page
- Gambar kendaraan fullscreen
- Spesifikasi kendaraan (kursi, transmisi, bahan bakar, tahun)
- Deskripsi detail
- Date Range Picker untuk memilih tanggal sewa
- Kalkulasi harga otomatis
- Tombol "Tambah ke Keranjang"

### 3. Search Page
- Search field dengan real-time filtering
- Hasil pencarian dinamis
- Filter by name dan brand
- Grid layout hasil pencarian

### 4. Cart Page
- List item keranjang dengan gambar
- Informasi durasi sewa dan harga
- Total pembayaran
- Tombol checkout & clear cart
- Delete individual items

### 5. Profile Page
- Avatar & info user
- Menu navigasi
- Riwayat pemesanan
- Metode pembayaran
- Settings

### 6. Navigation
- **Google Nav Bar** - 4 tab utama
- Modern design dengan smooth transitions
- Animated tab switching

## 🔄 State Management (Provider/Riverpod)

### Vehicle Provider
```dart
vehiclesProvider              // Semua kendaraan
popularVehiclesProvider       // Kendaraan terpopuler
vehicleDetailProvider         // Detail kendaraan
selectedCategoryProvider      // Kategori terpilih
searchResultsProvider         // Hasil pencarian
```

### Cart Provider
```dart
cartProvider                  // List item keranjang
cartTotalPriceProvider        // Total harga
cartCountProvider             // Jumlah item
```

### Date Range Provider
```dart
dateRangeProvider             // Range tanggal sewa
rentalDaysProvider            // Jumlah hari sewa
```

## 💾 Data Flow

```
UI → Provider (State Management)
  ↓
Use Cases (Business Logic)
  ↓
Repository (Abstraction)
  ↓
Data Source (API/Local)
  ↓
Entity/Model (Data)
```

## 🔧 Implementasi Features

### 1. Date Range Picker
- Custom widget dengan Material DatePicker
- Validasi date range
- Kalkulasi otomatis jumlah hari
- Integrasi dengan cart

### 2. Cart System
- Add/Remove items
- Dynamic price calculation
- Local state management
- Persistent cart data (ready for SharedPreferences)

### 3. Search Functionality
- Real-time search filtering
- Case-insensitive matching
- Filter by name dan brand

### 4. Responsive UI
- Adaptive layouts
- SafeArea implementation
- SliverAppBar untuk smooth scrolling
- GridView responsive

## 📝 Model Contoh: VehicleEntity

```dart
class VehicleEntity {
  final String id;
  final String name;
  final String brand;
  final VehicleCategory category;
  final FuelType fuelType;
  final TransmissionType transmission;
  final int seats;
  final String imageUrl;
  final double pricePerDay;
  final String licensePlate;
  final int year;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String description;
}

enum VehicleCategory {
  mobilKeluarga,
  mobilSport,
  mobilMewah,
  motor,
}

enum FuelType {
  bensin,
  diesel,
  hybrid,
  listrik,
}

enum TransmissionType {
  manual,
  otomatis,
}
```

## 🎯 Next Steps & Improvements

1. **Backend Integration**
   - Replace mock data dengan API calls (Dio)
   - Implement real authentication

2. **Local Storage**
   - Cache data dengan Hive/SharedPreferences
   - Offline functionality

3. **Payment Gateway**
   - Integrate Midtrans/Stripe
   - Real payment processing

4. **Firebase Integration**
   - Cloud Firestore untuk data
   - Firebase Auth
   - Firebase Storage untuk images

5. **Additional Features**
   - User reviews & ratings
   - Booking history
   - Notification system
   - Live chat support
   - GPS tracking
   - Document verification

6. **Testing**
   - Unit tests untuk usecases
   - Widget tests untuk UI
   - Integration tests

## 📄 License

Proyek ini dibuat untuk kebutuhan pembelajaran dan pengembangan.

## 👨‍💻 Developer

Dibuat dengan ❤️ menggunakan Flutter & Dart

---

**Catatan**: Mock data sudah tersedia di `VehicleModel.getMockVehicles()`. Untuk production, integrasikan dengan real API endpoint.
#   G O M O B I L E  
 