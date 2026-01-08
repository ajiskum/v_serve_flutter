class Admin {
  final String id;
  final String name;
  final String phone;
  final String role;
  final List<String> permissions;

  Admin({
    required this.id,
    required this.name,
    required this.phone,
    this.role = 'admin',
    required this.permissions,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String? ?? 'admin',
      permissions: List<String>.from(json['permissions'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'permissions': permissions,
    };
  }
}
