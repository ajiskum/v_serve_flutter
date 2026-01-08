class User {
  final String id;
  final String name;
  final String phone;
  final String villageId;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.villageId,
    this.email = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      villageId: json['villageId'] as String,
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'villageId': villageId,
      'email': email,
    };
  }
}
