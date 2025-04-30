enum UserRole { admin, operator }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isOperator => role == UserRole.operator;
} 