import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/workers.dart';
import '../mock_data/villages.dart';
import '../mock_data/service_requests.dart';
import '../models/service.dart';
import '../models/worker.dart';
import '../models/village.dart';
import '../models/service_request.dart';

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  void _navigateToDetail(BuildContext context, Worker worker) {
    Navigator.pushNamed(
      context, 
      '/worker_detail',
      arguments: worker,
    );
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

    addServiceRequest(newRequest);

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
      backgroundColor: Colors.grey[50], // Light grey bg for cards to pop
      appBar: AppBar(
        title: Text('Workers for ${service.name}', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: skilledWorkers.isEmpty
          ? const Center(child: Text('No workers available'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: skilledWorkers.length,
              itemBuilder: (context, index) {
                final worker = skilledWorkers[index];
                final isSameVillage = worker.villageId == currentUserVillage;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header: Name, Verified Badge, Rating
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text(
                                worker.name[0], 
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        worker.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(width: 6),
                                      // Verified Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
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
                                  Text(
                                    _getVillageName(worker.villageId),
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Text('${worker.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(width: 2),
                                      const Icon(Icons.star, size: 10, color: Colors.white),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('${worker.completedJobs} Jobs', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const Divider(height: 1),
                      
                      // Footer: Location Badge + Actions
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            if (isSameVillage)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Your Village', style: TextStyle(color: Colors.green[700], fontSize: 11, fontWeight: FontWeight.w600)),
                              )
                             else
                               Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Nearby', style: TextStyle(color: Colors.grey[700], fontSize: 11, fontWeight: FontWeight.w600)),
                              ),
                            
                            const Spacer(),
                            
                            OutlinedButton(
                              onPressed: () => _navigateToDetail(context, worker),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('View Profile', style: TextStyle(color: Colors.black)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _bookWorker(context, worker, service),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, // Premium Black
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('Book Now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
