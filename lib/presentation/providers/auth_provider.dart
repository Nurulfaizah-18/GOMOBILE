import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/local_storage_service.dart';

// Auth State class
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? user;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

// Auth Notifier with persistent storage
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    // Check if user was previously logged in
    _checkExistingSession();
  }

  /// Check existing session on app start
  void _checkExistingSession() {
    final currentUser = LocalStorageService.getCurrentUser();
    if (currentUser != null) {
      state = AuthState(
        isAuthenticated: true,
        user: currentUser,
      );
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Authenticate user from local storage
    final user = LocalStorageService.authenticateUser(
      email.toLowerCase().trim(),
      password,
    );

    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Email atau password salah',
      );
      return false;
    }

    // Save session
    await LocalStorageService.saveCurrentUser(user);

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: user,
    );
    return true;
  }

  /// Register new user
  Future<bool> register(String name, String email, String password,
      {String? phone}) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Validate email format
    if (!_isValidEmail(email)) {
      state = state.copyWith(
        isLoading: false,
        error: 'Format email tidak valid',
      );
      return false;
    }

    // Validate password length
    if (password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        error: 'Password minimal 6 karakter',
      );
      return false;
    }

    // Create new user
    final newUser = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': email.toLowerCase().trim(),
      'password': password,
      'role': 'user',
      'phone': phone ?? '',
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Try to add user
    final success = await LocalStorageService.addUser(newUser);

    if (!success) {
      state = state.copyWith(
        isLoading: false,
        error: 'Email sudah terdaftar',
      );
      return false;
    }

    // Auto login after register
    await LocalStorageService.saveCurrentUser(newUser);

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: newUser,
    );
    return true;
  }

  /// Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (state.user == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(milliseconds: 300));

    // Verify old password
    if (state.user!['password'] != oldPassword) {
      state = state.copyWith(
        isLoading: false,
        error: 'Password lama salah',
      );
      return false;
    }

    // Update password
    final users = LocalStorageService.loadUsers();
    final userIndex = users.indexWhere((u) => u['id'] == state.user!['id']);

    if (userIndex != -1) {
      users[userIndex]['password'] = newPassword;
      await LocalStorageService.saveUsers(users);

      // Update current user
      final updatedUser = Map<String, dynamic>.from(state.user!);
      updatedUser['password'] = newPassword;
      await LocalStorageService.saveCurrentUser(updatedUser);

      state = state.copyWith(
        isLoading: false,
        user: updatedUser,
      );
      return true;
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  /// Update profile
  Future<bool> updateProfile({String? name, String? phone}) async {
    if (state.user == null) return false;

    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 300));

    final users = LocalStorageService.loadUsers();
    final userIndex = users.indexWhere((u) => u['id'] == state.user!['id']);

    if (userIndex != -1) {
      if (name != null) users[userIndex]['name'] = name.trim();
      if (phone != null) users[userIndex]['phone'] = phone.trim();

      await LocalStorageService.saveUsers(users);

      // Update current user
      final updatedUser = Map<String, dynamic>.from(state.user!);
      if (name != null) updatedUser['name'] = name.trim();
      if (phone != null) updatedUser['phone'] = phone.trim();

      await LocalStorageService.saveCurrentUser(updatedUser);

      state = state.copyWith(
        isLoading: false,
        user: updatedUser,
      );
      return true;
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  /// Logout
  Future<void> logout() async {
    await LocalStorageService.logout();
    state = const AuthState();
  }

  /// Check if admin
  bool get isAdmin => state.user?['role'] == 'admin';

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Helper provider to check if user is admin
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?['role'] == 'admin';
});
