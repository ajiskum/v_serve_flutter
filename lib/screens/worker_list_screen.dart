import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../utils/responsive_helper.dart'; // Import
import '../mock_data/workers.dart';
import '../mock_data/villages.dart';
import '../mock_data/service_requests.dart';
import '../models/service.dart';
import '../models/worker.dart';
import '../models/village.dart';
import '../models/service_request.dart';

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {

  void _navigateToDetail(BuildContext context, Worker worker, Service service) {
    Navigator.pushNamed(
      context, 
      '/worker_detail',
      arguments: {'worker': worker, 'service': service},
    );
  }

  void _navigateToTracking(BuildContext context, ServiceRequest request) {
    Navigator.pushNamed(
      context,
      '/tracking',
      arguments: request,
    );
  }

  ServiceRequest? _getExistingRequest(String workerId, String serviceId) {
    final currentUser = Session.currentUser;
    if (currentUser == null) return null;

    try {
      return mockServiceRequests.firstWhere((req) => 
        req.userId == currentUser.id && 
        req.workerId == workerId &&
        req.serviceId == serviceId &&
        ['pending', 'accepted'].contains(req.status)
      );
    } catch (e) {
      return null;
    }
  }

  void _bookWorker(BuildContext context, Worker worker, Service service) {
    if (Session.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to book a service')),
      );
      return;
    }

    final newRequest = ServiceRequest(
      id: 'sr-${DateTime.now().millisecondsSinceEpoch}',
      userId: Session.currentUser.id,
      workerId: worker.id,
      serviceId: service.id,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    setState(() {
       addServiceRequest(newRequest);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request sent to ${worker.name}!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getVillageName(String villageId) {
    return mockVillages
        .firstWhere((v) => v.id == villageId, orElse: () => Village(id: '', name: 'Unknown', district: ''))
        .name;
  }

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)!.settings.arguments as Service;
    
    final skilledWorkers = mockWorkers.where((w) => w.isAvailable).toList();
    final currentUserVillage = Session.currentUser?.villageId;
    
    skilledWorkers.sort((a, b) {
      if (currentUserVillage == null) return 0;
      final aIsSame = a.villageId == currentUserVillage;
      final bIsSame = b.villageId == currentUserVillage;
      if (aIsSame && !bIsSame) return -1;
      if (!aIsSame && bIsSame) return 1;
      return 0;
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Workers for ${service.name}', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
           IconButton(
             onPressed: () => Navigator.pushNamed(context, '/user_profile'), 
             icon: const Icon(Icons.person_pin, color: AppColors.primary)
           ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: skilledWorkers.isEmpty
              ? const Center(child: Text('No workers available'))
              : GridView.builder( // Use GridView always, but column count changes
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context) ? 1 : 3, // 1 col Mobile, 3 cols Web
                    mainAxisExtent: 180, // Fixed height for cards
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: skilledWorkers.length,
                  itemBuilder: (context, index) {
                    final worker = skilledWorkers[index];
                    final isSameVillage = worker.villageId == currentUserVillage;
                    final existingRequest = _getExistingRequest(worker.id, service.id);
      
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  child: Text(worker.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                                            child: Row(
                                              children: const [
                                                Icon(Icons.check, size: 10, color: Colors.white),
                                                SizedBox(width: 2),
                                                Text('VERIFIED', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(_getVillageName(worker.villageId), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(4)),
                                      child: Row(
                                        children: [
                                          Text('${worker.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                          const SizedBox(width: 2),
                                          const Icon(Icons.star, size: 10, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const Spacer(),
                          const Divider(height: 1),
                          
                          // Footer
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                            child: Row(
                              children: [
                                 Text(
                                   isSameVillage ? 'Your Village' : 'Nearby',
                                   style: TextStyle(
                                     color: isSameVillage ? Colors.green[700] : Colors.grey[700], 
                                     fontWeight: FontWeight.bold,
                                     fontSize: 12
                                   ),
                                 ),
                                const Spacer(),
                                
                                widgetButtons(context, existingRequest, worker, service),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget widgetButtons(BuildContext context, ServiceRequest? existingRequest, Worker worker, Service service) {
    if (existingRequest != null) {
      if (existingRequest.status == 'pending') {
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300], 
              minimumSize: const Size(100, 36)
          ),
          child: const Text('Sent', style: TextStyle(color: Colors.black54)),
        );
      } else if (existingRequest.status == 'accepted') {
        return ElevatedButton(
          onPressed: () => _navigateToTracking(context, existingRequest),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success, 
            foregroundColor: Colors.white,
            minimumSize: const Size(100, 36)
          ),
          child: const Text('Track'),
        );
      }
    }
    
    return Row(
      children: [
        OutlinedButton(
          onPressed: () => _navigateToDetail(context, worker, service),
          style: OutlinedButton.styleFrom(
             minimumSize: const Size(80, 36),
             padding: EdgeInsets.zero,
          ),
          child: const Text('Profile'), // Shortened for grid
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _bookWorker(context, worker, service),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 36),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Book'),
        ),
      ],
    );
  }
}
