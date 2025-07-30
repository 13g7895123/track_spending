import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/local_storage_service.dart';

enum AuthStatus { 
  initial, 
  loading, 
  authenticated, 
  unauthenticated, 
  error 
}

class AuthProvider with ChangeNotifier {
  final UserRepository _userRepository;
  final LocalStorageService _localStorageService;

  AuthProvider({
    required UserRepository userRepository,
    required LocalStorageService localStorageService,
  }) : _userRepository = userRepository,
       _localStorageService = localStorageService {
    _checkAuthStatus();
  }

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> _checkAuthStatus() async {
    _setStatus(AuthStatus.loading);
    
    try {
      final userId = _localStorageService.getUserId();
      final token = _localStorageService.getUserToken();
      
      if (userId != null && token != null) {
        final user = await _userRepository.getCurrentUser();
        if (user != null) {
          _user = user;
          _setStatus(AuthStatus.authenticated);
        } else {
          await _logout();
        }
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to check authentication status: $e');
      await _logout();
    }
  }

  Future<void> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    
    try {
      final user = await _userRepository.login(email, password);
      
      // Save authentication data
      await _localStorageService.saveUserId(user.id);
      await _localStorageService.saveUserToken('mock_token_${user.id}');
      
      _user = user;
      _setStatus(AuthStatus.authenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> register(String email, String password, String name) async {
    _setStatus(AuthStatus.loading);
    
    try {
      final user = await _userRepository.register(email, password, name);
      
      // Save authentication data
      await _localStorageService.saveUserId(user.id);
      await _localStorageService.saveUserToken('mock_token_${user.id}');
      
      _user = user;
      _setStatus(AuthStatus.authenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> logout() async {
    _setStatus(AuthStatus.loading);
    await _logout();
  }

  Future<void> _logout() async {
    try {
      await _userRepository.logout();
      await _localStorageService.removeUserId();
      await _localStorageService.removeUserToken();
      
      _user = null;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError('Logout failed: $e');
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    if (!isAuthenticated) return;
    
    _setStatus(AuthStatus.loading);
    
    try {
      final user = await _userRepository.updateProfile(updatedUser);
      _user = user;
      _setStatus(AuthStatus.authenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    if (!isAuthenticated) return;
    
    try {
      await _userRepository.changePassword(currentPassword, newPassword);
      // Optionally show success message
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    if (!isAuthenticated) return;
    
    _setStatus(AuthStatus.loading);
    
    try {
      await _userRepository.deleteAccount();
      await _localStorageService.clearAll();
      
      _user = null;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    if (status != AuthStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _status = AuthStatus.error;
    notifyListeners();
  }
}