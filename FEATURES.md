# Feature Implementation Guide

## 🎯 Fitur-Fitur yang Sudah Diimplementasi

### ✅ 1. Dashboard Page
- [x] Menampilkan kendaraan terpopuler
- [x] Grid kategori kendaraan
- [x] List semua kendaraan
- [x] Pull-to-refresh
- [x] Smooth navigation ke detail

**File**: `lib/presentation/pages/dashboard_page.dart`

### ✅ 2. Vehicle Detail Page
- [x] Full-screen vehicle image
- [x] Spesifikasi kendaraan (kursi, transmisi, bahan bakar, tahun)
- [x] Deskripsi lengkap
- [x] Date Range Picker
- [x] Kalkulasi harga real-time
- [x] Add to cart functionality

**File**: `lib/presentation/pages/vehicle_detail_page.dart`

### ✅ 3. Cart Page
- [x] List cart items dengan gambar
- [x] Informasi durasi sewa
- [x] Total harga dinamis
- [x] Delete items
- [x] Clear cart
- [x] Checkout button

**File**: `lib/presentation/pages/cart_page.dart`

### ✅ 4. Search Page
- [x] Real-time search
- [x] Filter by name & brand
- [x] Grid display hasil
- [x] Empty state handling

**File**: `lib/presentation/pages/search_page.dart`

### ✅ 5. Profile Page
- [x] User profile card
- [x] Menu navigasi
- [x] Settings options
- [x] Logout functionality

**File**: `lib/presentation/pages/profile_page.dart`

### ✅ 6. Navigation
- [x] Google Nav Bar integration
- [x] 4 main tabs (Dashboard, Search, Cart, Profile)
- [x] Smooth transitions

**File**: `lib/presentation/pages/main_page.dart`

### ✅ 7. State Management
- [x] Vehicle provider (Riverpod)
- [x] Cart provider
- [x] Date range provider
- [x] Search provider

**Files**: `lib/presentation/providers/`

## 🔮 Fitur yang Perlu Diimplementasi

### 1. Firebase Integration *(Backend)*

```dart
// lib/presentation/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final userProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final signUpProvider = FutureProvider.family<UserCredential, String>((ref, email) async {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.createUserWithEmailAndPassword(
    email: email,
    password: 'password',
  );
});
```

### 2. Payment Gateway Integration *(Midtrans/Stripe)*

```dart
// lib/data/repositories/payment_repository_impl.dart
class PaymentRepositoryImpl implements PaymentRepository {
  @override
  Future<Either<Exception, PaymentResponse>> initiatePayment(
    double amount,
    String description,
  ) async {
    try {
      // Initialize Midtrans SDK
      const serverKey = 'YOUR_SERVER_KEY';
      
      // Create transaction token
      final transactionDetails = {
        'order_id': 'order-${DateTime.now().millisecondsSinceEpoch}',
        'gross_amount': amount,
      };
      
      // Get token from backend
      final response = await dio.post(
        'https://app.sandbox.midtrans.com/snap/v1/transactions',
        data: transactionDetails,
        options: Options(
          headers: {'Authorization': 'Basic $serverKey'},
        ),
      );
      
      return Right(PaymentResponse.fromJson(response.data));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
```

### 3. Persistent Cart Storage

```dart
// lib/data/datasources/local/cart_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences prefs;
  
  @override
  Future<void> saveCartItems(List<CartItemEntity> items) async {
    final jsonItems = items.map((item) => item.toJson()).toList();
    await prefs.setString('cart_items', jsonEncode(jsonItems));
  }
  
  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final json = prefs.getString('cart_items');
    if (json == null) return [];
    
    final items = jsonDecode(json) as List;
    return items.map((item) => CartItemEntity.fromJson(item)).toList();
  }
}
```

### 4. User Reviews & Ratings

```dart
// lib/domain/entities/review_entity.dart
class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String vehicleId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  
  const ReviewEntity({...});
}

// lib/presentation/pages/vehicle_detail_page.dart
// Add review section at bottom
Container(
  padding: EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ulasan Pengguna', style: Theme.of(context).textTheme.titleLarge),
      SizedBox(height: 12),
      reviewsAsync.when(
        data: (reviews) => ListView.builder(
          shrinkWrap: true,
          itemCount: reviews.length,
          itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
        ),
        loading: () => CircularProgressIndicator(),
        error: (e, st) => Text('Error loading reviews'),
      ),
    ],
  ),
)
```

### 5. GPS Tracking & Location

```dart
// lib/domain/entities/location_entity.dart
class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  
  const LocationEntity({...});
}

// lib/presentation/widgets/map_widget.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LocationEntity rentalLocation;
  final LocationEntity dropoffLocation;
  
  @override
  State<MapWidget> createState() => _MapWidgetState();
}
```

### 6. Booking History & Order Tracking

```dart
// lib/presentation/pages/orders_history_page.dart
class OrdersHistoryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);
    
    return ordersAsync.when(
      data: (orders) => ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) => OrderCard(order: orders[index]),
      ),
      loading: () => LoadingWidget(),
      error: (e, st) => ErrorWidget(),
    );
  }
}
```

### 7. Push Notifications

```dart
// lib/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    // Request permission
    await _firebaseMessaging.requestPermission();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      print('Message received: ${message.notification?.title}');
    });
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }
  
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Background message: ${message.notification?.title}');
  }
}
```

### 8. Offline Functionality

```dart
// lib/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.asBroadcastStream();
});

// Usage dalam provider
final vehiclesProvider = FutureProvider<List<VehicleEntity>>((ref) async {
  final connectivity = await ref.watch(connectivityProvider).first;
  
  if (connectivity == ConnectivityResult.none) {
    // Return cached data
    return ref.watch(cachedVehiclesProvider);
  }
  
  // Fetch dari API
  return ref.watch(remoteVehiclesProvider);
});
```

### 9. Document Verification

```dart
// lib/domain/entities/license_entity.dart
class LicenseEntity extends Equatable {
  final String id;
  final String userId;
  final String licenseNumber;
  final DateTime expiryDate;
  final String photoUrl;
  final String status; // pending, verified, rejected
  
  const LicenseEntity({...});
}

// lib/presentation/pages/license_verification_page.dart
class LicenseVerificationPage extends StatefulWidget {
  @override
  State<LicenseVerificationPage> createState() => _LicenseVerificationPageState();
}
```

### 10. Promo & Discount System

```dart
// lib/domain/entities/promo_entity.dart
class PromoEntity extends Equatable {
  final String id;
  final String code;
  final String description;
  final double discountAmount;
  final double discountPercentage;
  final DateTime expiryDate;
  final bool isActive;
  
  const PromoEntity({...});
}

// Usage di cart
final appliedPromoProvider = StateProvider<PromoEntity?>((ref) => null);

final finalPriceProvider = Provider<double>((ref) {
  final totalPrice = ref.watch(cartTotalPriceProvider);
  final promo = ref.watch(appliedPromoProvider);
  
  if (promo == null) return totalPrice;
  
  if (promo.discountPercentage > 0) {
    return totalPrice * (1 - promo.discountPercentage / 100);
  }
  
  return totalPrice - promo.discountAmount;
});
```

## 🔧 Implementation Priority

1. **Phase 1** (Current) - Core Features
   - Dashboard, Detail, Cart, Search, Profile
   - State Management
   - Mock Data

2. **Phase 2** - Backend Integration
   - Firebase Setup
   - API Integration
   - Authentication

3. **Phase 3** - Advanced Features
   - Payment Gateway
   - Notifications
   - Booking History

4. **Phase 4** - Optimization
   - Offline Support
   - Caching
   - Performance Tuning

## 📋 Development Checklist

- [ ] Test all pages navigation
- [ ] Test cart add/remove/update
- [ ] Test date range picker
- [ ] Test search functionality
- [ ] Test responsive UI on different screen sizes
- [ ] Implement Firebase auth
- [ ] Setup payment gateway
- [ ] Add push notifications
- [ ] Implement offline mode
- [ ] Add unit tests
- [ ] Add widget tests
- [ ] Performance optimization

---

Referensi untuk setiap implementasi tersedia di dokumentasi resmi masing-masing package.
