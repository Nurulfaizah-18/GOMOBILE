# 🚀 Quick Start Guide - UI Components & Pages

Panduan cepat untuk menggunakan semua halaman dan komponen UI yang telah dibuat.

## 📄 File-File Baru Yang Dibuat

### **Pages** (4 halaman baru)
```
✅ splash_page.dart          - Splash screen (3 detik)
✅ landing_page.dart         - Landing page dengan features
✅ profile_page.dart         - Profile page (updated)
✅ user_dashboard_page.dart  - Dashboard lengkap
```

### **Widget Components**
```
✅ custom_buttons.dart       - PrimaryButton, SecondaryButton, TextButton
✅ custom_input_fields.dart  - CustomTextField, CustomSearchField, CustomDropdownField
✅ custom_cards.dart         - CustomCard, InfoCard, FeatureCard, BookingSummaryCard
✅ custom_dialogs.dart       - CustomDialog, ConfirmationDialog, BottomSheetModal, FilterBottomSheet, SuccessDialog
✅ index.dart (pages)        - Export semua pages
✅ index.dart (widgets)      - Export semua widgets
```

---

## 🎯 Implementasi Navigation

### Setup di main.dart
```dart
import 'package:rental_kendaraan/exports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Kendaraan',
      theme: AppTheme.darkTheme(),
      home: const SplashPage(), // 👈 Start dengan SplashPage
      routes: {
        '/splash': (_) => const SplashPage(),
        '/landing': (_) => const LandingPage(),
        '/home': (_) => const MainPage(),
        '/dashboard': (_) => const UserDashboardPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
```

---

## 🎨 Menggunakan Komponen

### 1. **Button Components**

#### Primary Button (CTA)
```dart
PrimaryButton(
  label: 'Book Now',
  onPressed: () {
    // Handle booking
  },
  width: double.infinity,
  height: 48,
  backgroundColor: AppColors.electricBlue,
  icon: Icons.calendar_today,
)
```

#### Secondary Button
```dart
SecondaryButton(
  label: 'Cancel',
  onPressed: () => Navigator.pop(context),
  borderColor: AppColors.electricBlue,
  textColor: AppColors.electricBlue,
)
```

#### Text Button
```dart
TextButton(
  label: 'Forgot Password?',
  onPressed: () => resetPassword(),
  textColor: AppColors.electricBlue,
  icon: Icons.help,
)
```

---

### 2. **Input Components**

#### Text Field dengan Label & Validation
```dart
CustomTextField(
  label: 'Vehicle Name',
  hintText: 'Enter vehicle name...',
  prefixIcon: Icons.directions_car,
  keyboardType: TextInputType.text,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Required field';
    return null;
  },
  onChanged: (value) => filterVehicles(value),
)
```

#### Search Field
```dart
CustomSearchField(
  hintText: 'Search vehicles...',
  controller: searchController,
  onChanged: (value) => performSearch(value),
  onClear: () => clearSearch(),
  onSearch: () => submitSearch(),
)
```

#### Dropdown Field
```dart
CustomDropdownField<String>(
  label: 'Vehicle Type',
  value: selectedType,
  items: [
    DropdownMenuItem(value: 'sedan', child: Text('Sedan')),
    DropdownMenuItem(value: 'suv', child: Text('SUV')),
    DropdownMenuItem(value: 'mpv', child: Text('MPV')),
  ],
  onChanged: (value) => setState(() => selectedType = value),
)
```

---

### 3. **Card Components**

#### Custom Card (Base)
```dart
CustomCard(
  padding: EdgeInsets.all(16),
  backgroundColor: AppColors.darkCard,
  borderRadius: 12,
  onTap: () => handleCardTap(),
  child: Text('Card Content'),
)
```

#### Info Card (untuk statistik)
```dart
InfoCard(
  title: 'Total Bookings',
  value: '25',
  icon: Icons.calendar_today,
  iconColor: Colors.blue,
  onTap: () => viewAllBookings(),
)
```

#### Feature Card
```dart
FeatureCard(
  title: 'Flexible Rental',
  description: 'Rent for hourly, daily, or weekly basis with our flexible plans',
  icon: Icons.access_time,
  backgroundColor: AppColors.darkCard,
  iconColor: AppColors.electricBlue,
)
```

#### Booking Summary Card
```dart
BookingSummaryCard(
  vehicleModel: 'Honda Civic 2023',
  licensePlate: 'B 1234 ABC',
  startDate: '01 Jan 2024',
  endDate: '05 Jan 2024',
  totalDays: '5',
  totalPrice: 'Rp 2.500.000',
  onEdit: () => editBooking(),
  onCancel: () => cancelBooking(),
)
```

---

### 4. **Dialog Components**

#### Confirmation Dialog
```dart
showDialog(
  context: context,
  builder: (_) => ConfirmationDialog(
    title: 'Delete Vehicle',
    message: 'Are you sure you want to delete this vehicle?',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    isDestructive: true,
    onConfirm: () => deleteVehicle(),
    onCancel: () => Navigator.pop(context),
  ),
)
```

#### Success Dialog
```dart
showDialog(
  context: context,
  builder: (_) => SuccessDialog(
    title: 'Booking Confirmed',
    message: 'Your vehicle has been booked successfully!',
    duration: Duration(seconds: 3),
    onDismiss: () => navigateToDashboard(),
  ),
)
```

#### Bottom Sheet Modal
```dart
BottomSheetModal(
  title: 'Filter Options',
  isDismissible: true,
  child: Column(
    children: [
      // Filter content
    ],
  ),
).show(context)
```

#### Filter Bottom Sheet
```dart
showModalBottomSheet(
  context: context,
  builder: (_) => FilterBottomSheet(
    filters: {
      'Type': ['Sedan', 'SUV', 'MPV'],
      'Price': ['<Rp 500K', 'Rp 500K-1M', '>Rp 1M'],
      'Rating': ['4+', '3+', '2+'],
    },
    onApply: (selectedFilters) => applyFilters(selectedFilters),
    onReset: () => resetFilters(),
  ),
)
```

---

### 5. **Utility Widgets**

#### Dashboard Header (dengan dynamic greeting)
```dart
// Automatically shows greeting based on time
// Selamat Pagi (Morning), Siang (Afternoon), Sore (Evening), Malam (Night)
DashboardHeader()
```

#### Promo Banner
```dart
PromobannerWidget(
  title: 'Summer Special',
  subtitle: 'Get 30% discount on all vehicles',
  buttonText: 'Claim Offer',
  onButtonPressed: () => claimOffer(),
  bannerColor: Colors.green,
)
```

#### Section Header
```dart
SectionHeader(
  title: 'Popular Vehicles',
  actionText: 'View All',
  onActionPressed: () => viewAllVehicles(),
  actionIcon: Icons.arrow_forward,
)
```

#### Rating Bar (Display)
```dart
RatingBar(
  rating: 4.5,
  itemCount: 5,
  color: Colors.amber,
  size: 20,
  mainAxisAlignment: MainAxisAlignment.start,
  showRating: true,
)
```

#### Rating Bar (Interactive)
```dart
InteractiveRatingBar(
  initialRating: 0,
  itemCount: 5,
  color: Colors.amber,
  size: 24,
  onRatingChanged: (rating) => submitRating(rating),
)
```

#### Empty State Widget
```dart
EmptyStateWidget(
  icon: Icons.favorite_outline,
  title: 'No Favorites',
  description: 'You haven\'t added any favorites yet. Start adding your favorite vehicles!',
  buttonText: 'Browse Vehicles',
  onButtonPressed: () => browsVehicles(),
)
```

#### Shimmer Loading
```dart
// Single card
ShimmerLoadingCard(
  height: 200,
  width: double.infinity,
  borderRadius: 12,
)

// Grid of cards
ShimmerLoadingGrid(
  itemCount: 6,
  crossAxisCount: 2,
)
```

---

## 📱 Halaman-Halaman

### 1. **SplashPage**
```dart
// Auto-navigate setelah 3 detik
SplashPage()

// Atau di main.dart
home: SplashPage(),
```

### 2. **LandingPage**
```dart
// User akan melihat features dan click "Mulai Sekarang"
// Automatically navigates ke MainPage
LandingPage()
```

### 3. **ProfilePage**
```dart
// Simple profile dengan 3 action buttons
ProfilePage()

// Buttons: Menu, Pesanan, Logout
```

### 4. **UserDashboardPage**
```dart
// Comprehensive dashboard dengan:
// - Statistics
// - Promo banner
// - Activity timeline
// - Quick actions
// - Featured vehicles
UserDashboardPage()
```

---

## 🎨 Color Usage

```dart
import 'package:rental_kendaraan/exports.dart';

// Primary Accent
AppColors.electricBlue      // #00D9FF
AppColors.electricBlueDark  // #0099CC

// Backgrounds
AppColors.darkBg      // #0F1419
AppColors.darkCard    // #242B34
AppColors.darkSurface // #1A1F26

// Text
AppColors.textPrimary   // #F3F4F6 (white-ish)
AppColors.textSecondary // #9CA3AF (grey)
AppColors.textTertiary  // #6B7280 (dark grey)

// Status
AppColors.success   // #10B981 (green)
AppColors.warning   // #F59E0B (orange)
AppColors.error     // #EF4444 (red)

// UI Elements
AppColors.borderColor  // #374151
AppColors.dividerColor // #1F2937
```

---

## 🔄 Common Patterns

### Pattern 1: Form dengan Validation
```dart
class FormExample extends StatefulWidget {
  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Name',
            controller: _nameController,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Name is required';
              return null;
            },
          ),
          SizedBox(height: 16),
          PrimaryButton(
            label: 'Submit',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Submit form
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
```

### Pattern 2: List dengan Empty State
```dart
// Menggunakan ListView.builder + EmptyStateWidget
if (vehicles.isEmpty) {
  EmptyStateWidget(
    icon: Icons.directions_car,
    title: 'No Vehicles',
    description: 'No vehicles available at the moment',
  )
} else {
  ListView.builder(
    itemCount: vehicles.length,
    itemBuilder: (context, index) {
      return VehicleCard(vehicle: vehicles[index]);
    },
  )
}
```

### Pattern 3: Loading dengan Shimmer
```dart
// Saat loading
if (isLoading) {
  ShimmerLoadingGrid(itemCount: 6, crossAxisCount: 2)
} else if (vehicles.isEmpty) {
  EmptyStateWidget(...)
} else {
  GridView(...)
}
```

### Pattern 4: Dialog dengan Confirmation
```dart
// Delete confirmation
showDialog(
  context: context,
  builder: (_) => ConfirmationDialog(
    title: 'Delete?',
    message: 'This action cannot be undone',
    confirmText: 'Delete',
    isDestructive: true,
    onConfirm: () {
      delete();
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          title: 'Deleted',
          message: 'Item deleted successfully',
        ),
      );
    },
  ),
)
```

---

## 📚 Import Examples

### Single Import (Recommended)
```dart
import 'package:rental_kendaraan/exports.dart';
```

### Selective Imports
```dart
// Pages
import 'package:rental_kendaraan/presentation/pages/splash_page.dart';
import 'package:rental_kendaraan/presentation/pages/landing_page.dart';
import 'package:rental_kendaraan/presentation/pages/user_dashboard_page.dart';

// Components
import 'package:rental_kendaraan/presentation/widgets/custom_buttons.dart';
import 'package:rental_kendaraan/presentation/widgets/custom_input_fields.dart';
import 'package:rental_kendaraan/presentation/widgets/custom_dialogs.dart';

// Theme
import 'package:rental_kendaraan/core/theme/app_colors.dart';
```

---

## ✅ Checklist untuk Implementasi

- [ ] Update main.dart dengan SplashPage as home
- [ ] Test splash screen timer (3 detik)
- [ ] Verify landing page animations
- [ ] Test profile page buttons
- [ ] Integrate UserDashboardPage ke navigation
- [ ] Test semua button variants
- [ ] Test form validation
- [ ] Test dialog/modal interactions
- [ ] Verify color consistency
- [ ] Test animations pada different devices
- [ ] Test responsive layout pada berbagai ukuran screen

---

## 🐛 Troubleshooting

### Error: "Widget not found"
```
Solution: Ensure you've imported from exports.dart atau specific widget file
import 'package:rental_kendaraan/exports.dart';
```

### Error: "AppColors color not defined"
```
Solution: Check app_colors.dart dan gunakan yang tersedia:
- AppColors.electricBlue ✅
- AppColors.darkBg ✅
- AppColors.darkBackground ✅ (alias)
```

### Animation not smooth
```
Solution: Ensure you're using proper scroll physics:
SingleChildScrollView(physics: BouncingScrollPhysics())
```

### Dialog not closing
```
Solution: Always use Navigator.pop() dalam onConfirm/onDismiss:
onConfirm: () {
  Navigator.pop(context); // Close dialog
  handleAction();
}
```

---

## 📖 Documentation Files

- **PAGES_DOCUMENTATION.md** - Detail halaman-halaman
- **UI_COMPONENTS_SUMMARY.md** - Summary komponen
- **QUICK_START.md** - Quick start guide (this file)
- **ARCHITECTURE.md** - Architecture overview
- **FEATURES.md** - Features list

---

## 🎓 Next Steps

1. ✅ Integrate pages ke navigation
2. ✅ Customize colors untuk brand Anda
3. ✅ Populate dengan real data
4. ✅ Add state management (Riverpod)
5. ✅ Test di berbagai devices
6. ✅ Deploy ke production

---

## 💡 Tips & Best Practices

1. **Always use const constructors** untuk performance
2. **Use SafeArea** untuk handle notches/status bars
3. **Wrap lists dengan NeverScrollableScrollPhysics** jika nested
4. **Use SingleChildScrollView** untuk flexible height
5. **Import dari exports.dart** untuk consistency
6. **Follow AppColors naming** untuk theme consistency
7. **Use proper button types** sesuai use case
8. **Handle dialogs with Navigator.pop()** untuk clean closing

---

**Last Updated**: December 30, 2025
**Version**: 1.0.0
**Status**: Ready for Production ✅
