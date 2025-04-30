import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  final Map<String, User> _users = {};

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

  AuthProvider() {
    // Initialize with default users
    _users.addAll(_defaultUsers);
  }

  Future<bool> login(String email, String password) async {
    // In a real app, this would validate against a backend
    // For now, we'll just check against our users
    if (_users.containsKey(email)) {
      _currentUser = _users[email];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password, UserRole role) async {
    // Check if email already exists
    if (_users.containsKey(email)) {
      return false;
    }

    // Create new user with selected role
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      role: role,
    );

    // Add to users map
    _users[email] = newUser;
    
    // Auto login after registration
    _currentUser = newUser;
    notifyListeners();
    
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
} 