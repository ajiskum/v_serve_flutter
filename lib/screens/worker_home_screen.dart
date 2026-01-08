import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/service_requests.dart';
import '../mock_data/users.dart';
import '../mock_data/services.dart';
import '../models/user.dart';
import '../models/service.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {

  String _getUserName(String userId) {
    return mockUsers.firstWhere(
      (u) => u.id == userId, 
      orElse: () => User(id: '', name: 'Unknown', phone: '', villageId: ''),
    ).name;
  }

  String _getServiceName(String serviceId) {
    return mockServices.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => Service(id: '', categoryId: '', name: 'Unknown Service', description: '', price: 0, isAvailable: false),
    ).name;
  }

  @override
  Widget build(BuildContext context) {
    final currentWorkerId = Session.currentUser?.id;

    // Filter requests for this worker
    final myRequests = mockServiceRequests.where((req) => req.workerId == currentWorkerId).toList();
    
    // Sort: Pending first, then by date
    myRequests.sort((a, b) {
      if (a.status == 'pending' && b.status != 'pending') return -1;
      if (a.status != 'pending' && b.status == 'pending') return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${Language.get('worker')} Dashboard'),
      ),
      body: myRequests.isEmpty
          ? const Center(child: Text('No job requests yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: myRequests.length,
              itemBuilder: (context, index) {
                final request = myRequests[index];
                Color statusColor;
                switch (request.status) {
                  case 'pending': statusColor = Colors.orange; break;
                  case 'completed': statusColor = Colors.green; break;
                  default: statusColor = Colors.grey;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
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
                              style: AppTextStyles.subHeading,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                request.status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Customer: ${_getUserName(request.userId)}'),
                        Text('Date: ${request.createdAt.toString().split('.')[0]}'),
                        const SizedBox(height: 16),
                        if (request.status == 'pending')
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Reject Logic
                                  },
                                  child: const Text('REJECT'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                     // Accept Logic (Mock)
                                     setState(() {
                                       // In real app, we update the object status
                                       // Since we can't easily modify fields of const/final classes in deep lists without helper
                                       // We will just assume it's updated for UI demo or create mutable logic later.
                                       // For now, let's just show it's clickable.
                                     });
                                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job Accepted!')));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('ACCEPT'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
