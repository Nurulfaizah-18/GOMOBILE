# 📱 Landing & Dashboard Pages Documentation

Dokumentasi lengkap untuk semua halaman landing dan dashboard yang telah dibuat untuk aplikasi Rental Kendaraan.

## 🎯 Daftar Halaman

### 1. **SplashPage** - Halaman Splash Screen
- **File**: `lib/presentation/pages/splash_page.dart`
- **Durasi**: 3 detik
- **Fitur**:
  - Animated concentric circles dengan ElasticOut curve
  - Loading spinner di bagian bawah
  - Auto-navigate ke Landing Page setelah 3 detik
  - Greeting text dan app name
  - Gradient background

**Navigasi**:
```
SplashPage → LandingPage (3 detik otomatis)
```

---

### 2. **LandingPage** - Halaman Landing Awal
- **File**: `lib/presentation/pages/landing_page.dart`
- **Durasi**: Unlimited (user-triggered)
- **Fitur**:
  - Welcome message dengan animations (Fade + Slide)
  - Feature highlights (3 cards):
    - Pilihan Luas
    - Fleksibel
    - Aman
  - Decorative gradient circles di background
  - Responsive layout dengan SingleChildScrollView
  - Dua button actions

**Buttons**:
- **"Mulai Sekarang"** (Primary) → Navigate ke MainPage
- **"Pelajari Lebih Lanjut"** (Secondary) → Navigate ke MainPage

**Animasi**:
```dart
FadeTransition + SlideTransition
Duration: 800ms
Curve: easeInOutCubic
```

---

### 3. **ProfilePage** - Halaman Profil/Dasbor Sederhana
- **File**: `lib/presentation/pages/profile_page.dart`
- **Background**: Electric Blue (AppColors.electricBlue)
- **Fitur Utama**:
  - Judul "Dasbor"
  - Avatar user dengan border white
  - Nama user (Ghani Zulhusni Bahri)
  - 3 Action buttons dengan grey background:
    - **Menu** - Navigate ke dashboard
    - **Pesanan** - Navigate ke orders page
    - **Logout** - Show confirmation dialog

**Layout**:
```
┌─────────────────────┐
│      Dasbor         │
├─────────────────────┤
│                     │
│   [Avatar Icon]     │
│                     │
├─────────────────────┤
│ Ghani Zulhusni ... │
├─────────────────────┤
│   [Menu Button]     │
│  [Orders Button]    │
│  [Logout Button]    │
└─────────────────────┘
```

**Styling**:
- Background: Electric Teal (#00D9FF)
- Avatar: White border (3px)
- Buttons: Grey[700] background
- Text: White color

**Navigasi**:
```
ProfilePage ──→ MainPage (Menu)
           ──→ OrdersPage (Pesanan)
           ──→ SplashPage (Logout)
```

---

### 4. **UserDashboardPage** - Halaman Dashboard Lengkap
- **File**: `lib/presentation/pages/user_dashboard_page.dart`
- **Background**: Dark mode (AppColors.darkBg)
- **Scroll**: BouncingScrollPhysics

**Sections**:

#### a. **DashboardHeader**
Menampilkan:
- Dynamic greeting (Selamat Pagi/Siang/Sore/Malam)
- User avatar
- Search bar
- User info

#### b. **Statistik Section**
Grid 3 kolom menampilkan:
- **Aktif** (3 kendaraan)
- **Dibooking** (2 kendaraan)
- **Rating** (4.8 bintang)

Menggunakan `InfoCard` widget.

#### c. **Promo Banner**
Promotional banner dengan:
- Title & Subtitle
- Button "Gunakan Sekarang"
- Green gradient background
- Car icon decoration

#### d. **Aktivitas Terbaru**
List 3 activity items:
1. Booking Selesai (Honda Civic - 2 jam lalu)
2. Invoice Dibuat (Rp 1.200.000 - Kemarin)
3. Rating Diberikan (5 bintang - 3 hari lalu)

Menggunakan `_buildActivityItem()` helper.

#### e. **Aksi Cepat (Quick Actions)**
Grid 2x2 buttons:
- Booking Baru
- Riwayat
- Favorit
- Pembayaran

#### f. **Kendaraan Rekomendasi**
Horizontal scrollable list dengan featured vehicle cards:
- Honda Civic (Rp 500.000/hari, 4.8★)
- Toyota Avanza (Rp 350.000/hari, 4.6★)
- Suzuki Swift (Rp 400.000/hari, 4.9★)

**Layout**:
```
┌──────────────────────────────┐
│   DashboardHeader            │
├──────────────────────────────┤
│ Statistik Anda               │
│ ┌──────┐ ┌──────┐ ┌──────┐  │
│ │Aktif │ │Book │ │Rating│  │
│ └──────┘ └──────┘ └──────┘  │
├──────────────────────────────┤
│ Promo Banner Section         │
├──────────────────────────────┤
│ Aktivitas Terbaru            │
│ - Booking Selesai            │
│ - Invoice Dibuat             │
│ - Rating Diberikan           │
├──────────────────────────────┤
│ Aksi Cepat                   │
│ ┌──────────┐ ┌──────────┐   │
│ │Booking   │ │Riwayat   │   │
│ └──────────┘ └──────────┘   │
│ ┌──────────┐ ┌──────────┐   │
│ │Favorit   │ │Pembayaran│   │
│ └──────────┘ └──────────┘   │
├──────────────────────────────┤
│ Kendaraan Rekomendasi        │
│ ← [Card] [Card] [Card] →     │
└──────────────────────────────┘
```

---

## 🎨 Widgets yang Digunakan

### UI Component Widgets
- **DashboardHeader** - Header dengan greeting dinamis
- **PromobannerWidget** - Promotional banner
- **InfoCard** - Kartu info untuk statistik
- **CustomCard** - Base card component
- **SectionHeader** - Header section dengan action button
- **RatingBar** - Star rating display

### Button Widgets
- **PrimaryButton** - CTA button utama
- **SecondaryButton** - Outlined button
- **TextButton** - Text-only button

### Input Widgets
- **CustomTextField** - Text input field
- **CustomSearchField** - Search field
- **CustomDropdownField** - Dropdown selector

### Dialog Widgets
- **ConfirmationDialog** - Confirmation dialog
- **SuccessDialog** - Success notification
- **BottomSheetModal** - Bottom sheet modal
- **FilterBottomSheet** - Filter dialog

---

## 🔄 Navigation Flow

```
┌──────────────┐
│ SplashPage   │ (3 detik)
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ LandingPage  │ (User initiated)
└──────┬───────┘
       │
       ├─→ [Mulai Sekarang] ──→ MainPage
       │
       └─→ [Pelajari Lebih Lanjut] ──→ MainPage

MainPage (Dashboard Tab Navigation)
├─→ DashboardPage (Tab 1)
├─→ SearchPage (Tab 2)
├─→ CartPage (Tab 3)
└─→ ProfilePage (Tab 4)
    ├─→ [Menu] ──→ DashboardPage
    ├─→ [Pesanan] ──→ OrdersPage (TODO)
    └─→ [Logout] ──→ SplashPage (with confirmation)

UserDashboardPage (Alternative)
├─→ Statistik Anda
├─→ Promo Banner
├─→ Aktivitas Terbaru
├─→ Aksi Cepat
└─→ Kendaraan Rekomendasi
```

---

## 🎯 Fitur-Fitur Utama

### SplashPage
✅ Auto-navigate setelah 3 detik
✅ Animated circles dengan elastic curve
✅ Loading spinner
✅ Responsive design

### LandingPage
✅ Feature highlights dengan animations
✅ Gradient decorations
✅ Responsive layout
✅ Multiple CTA buttons

### ProfilePage
✅ Simple dan clean design
✅ Electric blue background
✅ User-friendly buttons
✅ Logout confirmation dialog

### UserDashboardPage
✅ Comprehensive dashboard
✅ Multiple sections
✅ Quick actions grid
✅ Featured vehicle carousel
✅ Activity timeline
✅ Statistics overview

---

## 📝 Penggunaan

### Import Widgets
```dart
// Single import
import 'package:rental_kendaraan/exports.dart';

// Atau import spesifik
import 'package:rental_kendaraan/presentation/pages/splash_page.dart';
import 'package:rental_kendaraan/presentation/pages/landing_page.dart';
import 'package:rental_kendaraan/presentation/pages/profile_page.dart';
import 'package:rental_kendaraan/presentation/pages/user_dashboard_page.dart';
```

### Implementasi Navigation di main.dart
```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashPage(), // Start dengan splash
      routes: {
        '/splash': (_) => const SplashPage(),
        '/landing': (_) => const LandingPage(),
        '/dashboard': (_) => const UserDashboardPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
```

---

## 🎨 Color Palette

**Dark Mode Theme**:
- `darkBg`: #0F1419 (Deep Grey/Black)
- `darkCard`: #242B34 (Card Background)
- `electricBlue`: #00D9FF (Accent Blue)
- `electricBlueDark`: #0099CC (Dark Blue)
- `textPrimary`: #F3F4F6 (Light Text)
- `textSecondary`: #9CA3AF (Medium Text)
- `borderColor`: #374151 (Border Grey)

---

## 📱 Responsive Design

Semua halaman menggunakan:
- ✅ `SafeArea` untuk safe zone
- ✅ `SingleChildScrollView` untuk scroll handling
- ✅ `BouncingScrollPhysics` untuk iOS-like feel
- ✅ Flexible padding/margin
- ✅ Responsive grid layouts

---

## ✨ Animasi

### SplashPage
- **Concentric Circles**: Scale animation dengan ElasticOut curve
- **Duration**: 1200ms per circle
- **Loop**: Infinite repeat

### LandingPage
- **Fade In**: Text dan content
- **Slide In**: From top/bottom
- **Duration**: 800ms
- **Curve**: EaseInOutCubic

### UserDashboardPage
- **Content Scroll**: BouncingScrollPhysics
- **Activity List**: Staggered animations

---

## 🔗 Related Files

- **Colors**: `lib/core/theme/app_colors.dart`
- **Widgets Index**: `lib/presentation/widgets/index.dart`
- **All Exports**: `lib/exports.dart`
- **Button Widgets**: `lib/presentation/widgets/custom_buttons.dart`
- **Input Widgets**: `lib/presentation/widgets/custom_input_fields.dart`
- **Dialog Widgets**: `lib/presentation/widgets/custom_dialogs.dart`

---

## 🚀 Next Steps

1. Integrate dengan real user data (SharedPreferences / Database)
2. Implement state management untuk dynamic greeting
3. Add push notifications untuk promo
4. Implement search functionality
5. Add analytics tracking
6. Improve accessibility (a11y)
7. Optimize animation performance

---

**Last Updated**: December 30, 2025
**Version**: 1.0
