class User {
  final int? id;
  final String name;
  final String? phone;
  final String password;
  final String role; // 'admin' or 'client'

  User({
    this.id,
    required this.name,
    this.phone,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      password: map['password'],
      role: map['role'] ?? 'client',
    );
  }
}
