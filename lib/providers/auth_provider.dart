import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isOperator => _currentUser?.isOperator ?? false;

  // Default accounts for testing
  static const Map<String, User> _defaultUsers = {
    'admin@smartfab.com': User(
      id: '1',
      email: 'admin@smartfab.com',
      name: 'Admin User',
      role: UserRole.admin,
    ),
    'operator@smartfab.com': User(
      id: '2',
      email: 'operator@smartfab.com',
      name: 'Operator User',
      role: UserRole.operator,
    ),
  };

  Future<bool> login(String email, String password) async {
    // In a real app, this would validate against a backend
    // For now, we'll just check against our default users
    if (_defaultUsers.containsKey(email)) {
      _currentUser = _defaultUsers[email];
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
} 