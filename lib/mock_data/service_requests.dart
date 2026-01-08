import '../models/service_request.dart';

List<ServiceRequest> mockServiceRequests = [
  ServiceRequest(
    id: 'sr1',
    userId: 'u1',
    workerId: 'w1',
    serviceId: 's1',
    status: 'completed',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    completedAt: DateTime.now().subtract(const Duration(days: 1)),
    notes: 'Fixed leakage in kitchen',
  ),
  ServiceRequest(
    id: 'sr2',
    userId: 'u2',
    workerId: 'w2',
    serviceId: 's4',
    status: 'pending',
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
];

void addServiceRequest(ServiceRequest request) {
  mockServiceRequests.add(request);
}
