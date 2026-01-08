class Village {
  final String id;
  final String name;
  final String district;

  Village({
    required this.id,
    required this.name,
    required this.district,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'district': district,
    };
  }
}
