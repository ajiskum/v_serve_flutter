class Worker {
  final String id;
  final String name;
  final String phone;
  final String villageId;
  final List<String> skills;
  final bool isAvailable;
  final double rating;
  final int completedJobs;

  final int experience;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.villageId,
    required this.skills,
    this.isAvailable = true,
    this.rating = 0.0,
    this.completedJobs = 0,
    this.experience = 0,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      villageId: json['villageId'] as String,
      skills: List<String>.from(json['skills'] as List),
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      completedJobs: json['completedJobs'] as int? ?? 0,
      experience: json['experience'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'villageId': villageId,
      'skills': skills,
      'isAvailable': isAvailable,
      'rating': rating,
      'completedJobs': completedJobs,
      'experience': experience,
    };
  }
}
