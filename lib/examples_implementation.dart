// ignore_for_file: unused_element

/// EXAMPLE: Complete Implementation Examples
/// File ini berisi contoh-contoh lengkap untuk berbagai scenario implementasi

// ============================================================================
// EXAMPLE 1: Firebase Authentication Integration
// ============================================================================

/*

// Tambah ke pubspec.yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.10.0
  google_sign_in: ^6.1.0

// lib/data/datasources/auth_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User?> signUpWithEmail(String email, String password);
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}

// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final signUpProvider = FutureProvider.family<void, 
  Map<String, String>>((ref, params) async {
  final auth = ref.watch(firebaseAuthProvider);
  await auth.createUserWithEmailAndPassword(
    email: params['email']!,
    password: params['password']!,
  );
});

*/

// ============================================================================
// EXAMPLE 2: API Integration dengan Dio
// ============================================================================

/*

// lib/data/datasources/vehicle_api_datasource.dart
import 'package:dio/dio.dart';
import '../models/vehicle_model.dart';

class VehicleApiDataSource {
  final Dio dio;
  static const String baseUrl = 'https://api.rental-kendaraan.com/api/v1';

  VehicleApiDataSource({required this.dio}) {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<List<VehicleModel>> getAllVehicles() async {
    try {
      final response = await dio.get('/vehicles');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((v) => VehicleModel.fromJson(v)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<VehicleModel> getVehicleById(String id) async {
    try {
      final response = await dio.get('/vehicles/$id');
      return VehicleModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<VehicleModel>> searchVehicles(String query) async {
    try {
      final response = await dio.get(
        '/vehicles/search',
        queryParameters: {'q': query},
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((v) => VehicleModel.fromJson(v)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return Exception('Connection timeout');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return Exception('Receive timeout');
    } else if (error.response != null) {
      return Exception(error.response?.data['message'] ?? 'API Error');
    }
    return Exception('Unknown error');
  }
}

// Setup di main.dart
void main() {
  final dio = Dio();
  final apiDataSource = VehicleApiDataSource(dio: dio);
  
  runApp(MyApp());
}

*/

// ============================================================================
// EXAMPLE 3: Local Storage dengan SharedPreferences
// ============================================================================

/*

// lib/data/datasources/cart_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _cartKey = 'cart_items';
  final SharedPreferences prefs;

  CartLocalDataSource({required this.prefs});

  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to save cart items: $e');
    }
  }

  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = prefs.getString(_cartKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      await prefs.remove(_cartKey);
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      final items = await getCartItems();
      items.removeWhere((item) => item.id == itemId);
      await saveCartItems(items);
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }
}

// lib/presentation/providers/persistent_cart_provider.dart
final cartPersistenceProvider = 
  FutureProvider<List<CartItemEntity>>((ref) async {
  final localDataSource = ref.watch(cartLocalDataSourceProvider);
  return localDataSource.getCartItems();
});

*/

// ============================================================================
// EXAMPLE 4: Payment Gateway Integration (Midtrans)
// ============================================================================

/*

// Tambah ke pubspec.yaml
dependencies:
  midtrans_sdk: ^1.1.5

// lib/domain/entities/payment_entity.dart
class PaymentEntity extends Equatable {
  final String id;
  final String transactionId;
  final String status;
  final double amount;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.transactionId,
    required this.status,
    required this.amount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, transactionId, status, amount, createdAt];
}

// lib/data/datasources/payment_datasource.dart
import 'package:midtrans_sdk/midtrans_sdk.dart';

class PaymentRemoteDataSource {
  final Dio dio;
  static const String _baseUrl = 'https://app.sandbox.midtrans.com';

  PaymentRemoteDataSource({required this.dio});

  Future<String> getSnapToken(
    String orderId,
    double amount,
    String customerEmail,
  ) async {
    try {
      final response = await dio.post(
        '$_baseUrl/snap/v1/transactions',
        data: {
          'transaction_details': {
            'order_id': orderId,
            'gross_amount': amount,
          },
          'customer_details': {
            'email': customerEmail,
          },
        },
        options: Options(
          headers: {
            'Authorization': 'Basic <YOUR_SERVER_KEY>',
          },
        ),
      );

      return response.data['token'];
    } catch (e) {
      throw Exception('Failed to get snap token: $e');
    }
  }

  Future<bool> initiatePayment(String snapToken) async {
    try {
      MidtransSDK.instance.setClientKey('<YOUR_CLIENT_KEY>');
      MidtransSDK.instance.setMerchantBaseUrl('<YOUR_BASE_URL>');
      
      final result = await MidtransSDK.instance
          .startPaymentUiFlow(token: snapToken);
      
      return result == null; // null means success
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }
}

// lib/presentation/pages/payment_page.dart
class PaymentPage extends ConsumerWidget {
  final double totalPrice;
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Pembayaran')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Get snap token
            final paymentDataSource = ref.read(paymentDataSourceProvider);
            final snapToken = await paymentDataSource.getSnapToken(
              orderId,
              totalPrice,
              'user@example.com',
            );

            // Initiate payment
            final success = await paymentDataSource.initiatePayment(snapToken);

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pembayaran berhasil')),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Bayar Rp ${totalPrice.toStringAsFixed(0)}'),
        ),
      ),
    );
  }
}

*/

// ============================================================================
// EXAMPLE 5: Offline Support dengan Hive
// ============================================================================

/*

// Tambah ke pubspec.yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.0

// lib/data/datasources/vehicle_hive_datasource.dart
import 'package:hive/hive.dart';
import '../models/vehicle_model.dart';

@HiveType(typeId: 0)
class VehicleHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double pricePerDay;

  VehicleHiveModel({
    required this.id,
    required this.name,
    required this.pricePerDay,
  });
}

class VehicleHiveDataSource {
  static const String _boxName = 'vehicles';

  Future<void> cacheVehicles(List<VehicleModel> vehicles) async {
    final box = await Hive.openBox<VehicleHiveModel>(_boxName);
    await box.clear();

    for (var vehicle in vehicles) {
      await box.put(
        vehicle.id,
        VehicleHiveModel(
          id: vehicle.id,
          name: vehicle.name,
          pricePerDay: vehicle.pricePerDay,
        ),
      );
    }
  }

  Future<List<VehicleModel>> getCachedVehicles() async {
    final box = await Hive.openBox<VehicleHiveModel>(_boxName);
    return box.values.map((v) => VehicleModel(...)).toList();
  }
}

// main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(VehicleHiveModelAdapter());

  runApp(const MyApp());
}

*/

// ============================================================================
// EXAMPLE 6: Push Notifications (Firebase Cloud Messaging)
// ============================================================================

/*

// Tambah ke pubspec.yaml
dependencies:
  firebase_messaging: ^14.7.0

// lib/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      cardinality: AndroidNotificationChannelDescription.default,
      critical: false,
      provisional: false,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Show local notification
        _showLocalNotification(message);
      }
    });

    // Handle background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification when app is terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print('Handling a background message: ${message.messageId}');
  }

  Future<String?> getDeviceToken() async {
    return await _messaging.getToken();
  }

  void _showLocalNotification(RemoteMessage message) {
    // Implement local notification display
    // Using flutter_local_notifications package
  }
}

*/

// ============================================================================
// EXAMPLE 7: Unit Testing
// ============================================================================

/*

// test/domain/usecases/vehicle_usecases_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rental_kendaraan/domain/usecases/vehicle_usecases.dart';
import 'package:rental_kendaraan/domain/entities/vehicle_entity.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late GetAllVehiclesUsecase usecase;
  late MockVehicleRepository mockRepository;

  setUp(() {
    mockRepository = MockVehicleRepository();
    usecase = GetAllVehiclesUsecase(mockRepository);
  });

  group('GetAllVehiclesUsecase', () {
    final testVehicles = [
      const VehicleEntity(
        id: '1',
        name: 'Toyota Avanza',
        brand: 'Toyota',
        category: VehicleCategory.mobilKeluarga,
        fuelType: FuelType.bensin,
        transmission: TransmissionType.manual,
        seats: 7,
        imageUrl: 'url',
        pricePerDay: 400000,
        licensePlate: 'B 1234 ABC',
        year: 2023,
        rating: 4.5,
        reviewCount: 100,
        isAvailable: true,
        description: 'Test vehicle',
      ),
    ];

    test('should return list of vehicles when successful', () async {
      // Arrange
      when(mockRepository.getAllVehicles())
          .thenAnswer((_) async => Right(testVehicles));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(testVehicles));
      verify(mockRepository.getAllVehicles()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when unsuccessful', () async {
      // Arrange
      final exception = Exception('Test error');
      when(mockRepository.getAllVehicles())
          .thenAnswer((_) async => Left(exception));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(exception));
    });
  });
}

*/

// ============================================================================
// EXAMPLE 8: Custom Error Handling
// ============================================================================

/*

// lib/core/exceptions/exceptions.dart
class VehicleException implements Exception {
  final String message;
  VehicleException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

// lib/core/utils/error_handler.dart
class ErrorHandler {
  static String handle(Exception exception) {
    if (exception is NetworkException) {
      return 'Network Error: ${exception.message}';
    } else if (exception is VehicleException) {
      return 'Vehicle Error: ${exception.message}';
    }
    return 'Unknown Error: $exception';
  }
}

// Usage
result.fold(
  (exception) {
    final message = ErrorHandler.handle(exception);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  },
  (data) {
    // Handle success
  },
);

*/

void examples() {
  // File ini berisi contoh-contoh implementasi
  // Gunakan sebagai referensi untuk feature development
}
