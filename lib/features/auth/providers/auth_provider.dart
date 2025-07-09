import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  
  Future<bool> login(String pin) async {
    // Simulate login
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _currentUserId = 'user_123';
    notifyListeners();
    return true;
  }
  
  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUserId = null;
    notifyListeners();
  }
}
