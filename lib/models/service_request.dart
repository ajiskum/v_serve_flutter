class ServiceRequest {
  final String id;
  final String userId;
  final String workerId;
  final String serviceId;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String notes;

  ServiceRequest({
    required this.id,
    required this.userId,
    required this.workerId,
    required this.serviceId,
    this.status = 'pending',
    required this.createdAt,
    this.completedAt,
    this.notes = '',
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workerId: json['workerId'] as String,
      serviceId: json['serviceId'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'workerId': workerId,
      'serviceId': serviceId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
    };
  }
}
