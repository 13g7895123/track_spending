import '../models/user_model.dart';
import '../services/mock_data_service.dart';

class UserRepository {
  final MockDataService _dataService;

  UserRepository(this._dataService);

  Future<User?> getCurrentUser() async {
    try {
      return await _dataService.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<User> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      if (!_isValidEmail(email)) {
        throw Exception('Invalid email format');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      final user = await _dataService.loginUser(email, password);
      if (user == null) {
        throw Exception('Invalid credentials');
      }

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw Exception('All fields are required');
      }

      if (!_isValidEmail(email)) {
        throw Exception('Invalid email format');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      if (name.length < 2) {
        throw Exception('Name must be at least 2 characters');
      }

      // For now, we'll create a mock user since this is demo data
      final now = DateTime.now();
      final newUser = User(
        id: 'user_${now.millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: now,
        updatedAt: now,
      );

      // In a real app, this would call the API
      // For now, we'll just return the created user
      return newUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _dataService.logoutUser();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<User> updateProfile(User user) async {
    try {
      if (user.name.isEmpty) {
        throw Exception('Name is required');
      }

      if (user.name.length < 2) {
        throw Exception('Name must be at least 2 characters');
      }

      // For now, just return the user with updated timestamp
      return user.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      if (currentPassword.isEmpty || newPassword.isEmpty) {
        throw Exception('Both passwords are required');
      }

      if (newPassword.length < 6) {
        throw Exception('New password must be at least 6 characters');
      }

      if (currentPassword == newPassword) {
        throw Exception('New password must be different from current password');
      }

      // In a real app, this would verify current password and update
      // For now, we'll just simulate the operation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      // In a real app, this would delete the account
      // For now, we'll just simulate the operation
      await Future.delayed(const Duration(milliseconds: 500));
      await _dataService.logoutUser();
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}