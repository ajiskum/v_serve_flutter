class Service {
  final String id;
  final String name;
  final String categoryId;
  final String description;
  final double price;
  final bool isAvailable;

  Service({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.price,
    this.isAvailable = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'price': price,
      'isAvailable': isAvailable,
    };
  }
}
