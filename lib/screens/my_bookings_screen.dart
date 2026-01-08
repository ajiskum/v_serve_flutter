import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/service_requests.dart';
import '../mock_data/services.dart';
import '../mock_data/workers.dart';
import '../models/service_request.dart';
import '../models/service.dart';
import '../models/worker.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  String _getServiceName(String serviceId) {
    return mockServices.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => Service(id: '', categoryId: '', name: 'Unknown Service', description: '', price: 0, isAvailable: false),
    ).name;
  }

  String _getWorkerName(String workerId) {
    return mockWorkers.firstWhere(
      (w) => w.id == workerId,
      orElse: () => Worker(id: '', name: 'Unknown Worker', phone: '', villageId: '', skills: [], isAvailable: false, rating: 0, completedJobs: 0),
    ).name;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'completed': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Session.currentUser?.id;
    
    // Filter requests for this user
    final myRequests = mockServiceRequests.where((req) => req.userId == currentUserId).toList();
    
    // Sort by Date (Newest first)
    myRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: myRequests.isEmpty
          ? const Center(child: Text('No bookings yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: myRequests.length,
              itemBuilder: (context, index) {
                final request = myRequests[index];
                final statusColor = _getStatusColor(request.status);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getServiceName(request.serviceId),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                request.status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                             const Icon(Icons.person, size: 14, color: Colors.grey),
                             const SizedBox(width: 4),
                             Text('Worker: ${_getWorkerName(request.workerId)}', style: TextStyle(color: Colors.grey[800])),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                             const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                             const SizedBox(width: 4),
                             Text(
                               'Date: ${request.createdAt.toString().split(' ')[0]}', 
                               style: TextStyle(color: Colors.grey[600], fontSize: 12)
                             ),
                          ],
                        ),
                        if (request.status == 'completed') ...[
                          const Divider(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Rate Logic Placeholder
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rating Submitted!')));
                              },
                              icon: const Icon(Icons.star_rate, size: 16),
                              label: const Text('Rate Worker'),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
