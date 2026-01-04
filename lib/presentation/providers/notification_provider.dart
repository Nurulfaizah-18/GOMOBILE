import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/local_storage_service.dart';

// Model notifikasi
class AdminNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'booking', 'payment', 'cancel'
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  AdminNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return AdminNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }

  // Create from JSON
  factory AdminNotification.fromJson(Map<String, dynamic> json) {
    return AdminNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'booking',
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}

// State notifier untuk notifikasi admin dengan persistent storage
class AdminNotificationNotifier extends StateNotifier<List<AdminNotification>> {
  AdminNotificationNotifier() : super([]) {
    _loadNotificationsFromStorage();
  }

  // Load notifications from storage
  void _loadNotificationsFromStorage() {
    final notificationsJson = LocalStorageService.loadNotifications();
    if (notificationsJson.isNotEmpty) {
      final notifications = notificationsJson
          .map((json) => AdminNotification.fromJson(json))
          .toList();
      state = notifications;
    }
  }

  // Save notifications to storage
  Future<void> _saveNotificationsToStorage() async {
    final notificationsJson = state.map((n) => n.toJson()).toList();
    await LocalStorageService.saveNotifications(notificationsJson);
  }

  // Tambah notifikasi baru
  void addNotification({
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) {
    final notification = AdminNotification(
      id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      data: data,
    );
    state = [notification, ...state];
    _saveNotificationsToStorage();
  }

  // Tandai notifikasi sudah dibaca
  void markAsRead(String notificationId) {
    state = state.map((notif) {
      if (notif.id == notificationId) {
        return notif.copyWith(isRead: true);
      }
      return notif;
    }).toList();
    _saveNotificationsToStorage();
  }

  // Tandai semua sudah dibaca
  void markAllAsRead() {
    state = state.map((notif) => notif.copyWith(isRead: true)).toList();
    _saveNotificationsToStorage();
  }

  // Hapus notifikasi
  void removeNotification(String notificationId) {
    state = state.where((notif) => notif.id != notificationId).toList();
    _saveNotificationsToStorage();
  }

  // Hapus semua notifikasi
  void clearAll() {
    state = [];
    _saveNotificationsToStorage();
  }

  // Hitung notifikasi yang belum dibaca
  int get unreadCount => state.where((n) => !n.isRead).length;
}

// Provider untuk notifikasi admin
final adminNotificationProvider =
    StateNotifierProvider<AdminNotificationNotifier, List<AdminNotification>>(
        (ref) {
  return AdminNotificationNotifier();
});

// Provider untuk jumlah notifikasi yang belum dibaca
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(adminNotificationProvider);
  return notifications.where((n) => !n.isRead).length;
});
