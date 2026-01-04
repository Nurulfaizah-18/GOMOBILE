import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/entities/rental_order_entity.dart';
import '../models/vehicle_model.dart';

/// Service untuk menyimpan data secara lokal (persisten)
class LocalStorageService {
  static const String _vehiclesKey = 'vehicles_data';
  static const String _ordersKey = 'orders_data';
  static const String _usersKey = 'users_data';
  static const String _currentUserKey = 'current_user';
  static const String _notificationsKey = 'notifications_data';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
          'LocalStorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ==================== VEHICLES ====================

  /// Save vehicles to local storage
  static Future<void> saveVehicles(List<VehicleEntity> vehicles) async {
    final List<Map<String, dynamic>> vehiclesJson = vehicles.map((v) {
      return {
        'id': v.id,
        'name': v.name,
        'brand': v.brand,
        'category': v.category.index,
        'fuelType': v.fuelType.index,
        'transmission': v.transmission.index,
        'seats': v.seats,
        'imageUrl': v.imageUrl,
        'pricePerDay': v.pricePerDay,
        'licensePlate': v.licensePlate,
        'year': v.year,
        'rating': v.rating,
        'reviewCount': v.reviewCount,
        'isAvailable': v.isAvailable,
        'description': v.description,
      };
    }).toList();
    await prefs.setString(_vehiclesKey, jsonEncode(vehiclesJson));
  }

  /// Load vehicles from local storage
  static List<VehicleEntity> loadVehicles() {
    final String? vehiclesJson = prefs.getString(_vehiclesKey);
    if (vehiclesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(vehiclesJson);
    return decoded.map((json) {
      return VehicleModel(
        id: json['id'],
        name: json['name'],
        brand: json['brand'],
        category: VehicleCategory.values[json['category']],
        fuelType: FuelType.values[json['fuelType']],
        transmission: TransmissionType.values[json['transmission']],
        seats: json['seats'],
        imageUrl: json['imageUrl'],
        pricePerDay: (json['pricePerDay'] as num).toDouble(),
        licensePlate: json['licensePlate'],
        year: json['year'],
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'],
        isAvailable: json['isAvailable'],
        description: json['description'],
      );
    }).toList();
  }

  // ==================== ORDERS ====================

  /// Save orders to local storage
  static Future<void> saveOrders(List<RentalOrderEntity> orders) async {
    final List<Map<String, dynamic>> ordersJson = orders.map((o) {
      return {
        'id': o.id,
        'vehicleId': o.vehicle.id,
        'vehicleName': o.vehicle.name,
        'vehicleBrand': o.vehicle.brand,
        'vehicleCategory': o.vehicle.category.index,
        'vehicleFuelType': o.vehicle.fuelType.index,
        'vehicleTransmission': o.vehicle.transmission.index,
        'vehicleSeats': o.vehicle.seats,
        'vehicleImageUrl': o.vehicle.imageUrl,
        'vehiclePricePerDay': o.vehicle.pricePerDay,
        'vehicleLicensePlate': o.vehicle.licensePlate,
        'vehicleYear': o.vehicle.year,
        'vehicleRating': o.vehicle.rating,
        'vehicleReviewCount': o.vehicle.reviewCount,
        'vehicleIsAvailable': o.vehicle.isAvailable,
        'vehicleDescription': o.vehicle.description,
        'startDate': o.startDate.toIso8601String(),
        'endDate': o.endDate.toIso8601String(),
        'rentalDays': o.rentalDays,
        'totalPrice': o.totalPrice,
        'status': o.status,
        'createdAt': o.createdAt.toIso8601String(),
      };
    }).toList();
    await prefs.setString(_ordersKey, jsonEncode(ordersJson));
  }

  /// Load orders from local storage
  static List<RentalOrderEntity> loadOrders() {
    final String? ordersJson = prefs.getString(_ordersKey);
    if (ordersJson == null) return [];

    final List<dynamic> decoded = jsonDecode(ordersJson);
    return decoded.map((json) {
      final vehicle = VehicleModel(
        id: json['vehicleId'],
        name: json['vehicleName'],
        brand: json['vehicleBrand'],
        category: VehicleCategory.values[json['vehicleCategory']],
        fuelType: FuelType.values[json['vehicleFuelType']],
        transmission: TransmissionType.values[json['vehicleTransmission']],
        seats: json['vehicleSeats'],
        imageUrl: json['vehicleImageUrl'],
        pricePerDay: (json['vehiclePricePerDay'] as num).toDouble(),
        licensePlate: json['vehicleLicensePlate'],
        year: json['vehicleYear'],
        rating: (json['vehicleRating'] as num).toDouble(),
        reviewCount: json['vehicleReviewCount'],
        isAvailable: json['vehicleIsAvailable'],
        description: json['vehicleDescription'],
      );

      return RentalOrderEntity(
        id: json['id'],
        vehicle: vehicle,
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        rentalDays: json['rentalDays'],
        totalPrice: (json['totalPrice'] as num).toDouble(),
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
      );
    }).toList();
  }

  // ==================== USERS ====================

  /// Save users to local storage
  static Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// Load users from local storage
  static List<Map<String, dynamic>> loadUsers() {
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) {
      // No default users - user must register first
      return [];
    }
    return List<Map<String, dynamic>>.from(jsonDecode(usersJson));
  }

  /// Add new user
  static Future<bool> addUser(Map<String, dynamic> user) async {
    final users = loadUsers();

    // Check if email already exists
    if (users.any((u) => u['email'] == user['email'])) {
      return false; // Email already registered
    }

    // First registered user becomes admin
    if (users.isEmpty) {
      user['role'] = 'admin';
    }

    users.add(user);
    await saveUsers(users);
    return true;
  }

  /// Authenticate user
  static Map<String, dynamic>? authenticateUser(String email, String password) {
    final users = loadUsers();
    try {
      return users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== CURRENT USER SESSION ====================

  /// Save current logged in user
  static Future<void> saveCurrentUser(Map<String, dynamic>? user) async {
    if (user == null) {
      await prefs.remove(_currentUserKey);
    } else {
      await prefs.setString(_currentUserKey, jsonEncode(user));
    }
  }

  /// Get current logged in user
  static Map<String, dynamic>? getCurrentUser() {
    final String? userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return Map<String, dynamic>.from(jsonDecode(userJson));
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return getCurrentUser() != null;
  }

  /// Logout - clear current user
  static Future<void> logout() async {
    await prefs.remove(_currentUserKey);
  }

  // ==================== NOTIFICATIONS ====================

  /// Save notifications
  static Future<void> saveNotifications(
      List<Map<String, dynamic>> notifications) async {
    await prefs.setString(_notificationsKey, jsonEncode(notifications));
  }

  /// Load notifications
  static List<Map<String, dynamic>> loadNotifications() {
    final String? notifJson = prefs.getString(_notificationsKey);
    if (notifJson == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(notifJson));
  }

  // ==================== CLEAR ALL DATA ====================

  /// Clear all stored data
  static Future<void> clearAll() async {
    await prefs.clear();
  }
}
