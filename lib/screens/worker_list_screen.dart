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
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
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
    
    // 1. Filter by Skill & Availability
    final skilledWorkers = mockWorkers.where((w) {
      // Loose matching for demo purposes as discussed in Phase 2
      return w.isAvailable;
    }).toList();

    // 2. Sort by Village Proximity
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
      appBar: AppBar(
        title: Text('Workers for ${service.name}'),
      ),
      body: skilledWorkers.isEmpty
          ? const Center(child: Text('No workers available'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: skilledWorkers.length,
              itemBuilder: (context, index) {
                final worker = skilledWorkers[index];
                final isSameVillage = worker.villageId == currentUserVillage;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: isSameVillage 
                      ? RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(worker.name, style: AppTextStyles.subHeading),
                            if (isSameVillage)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Your Village',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                               Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Nearby',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),


                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Village: ${_getVillageName(worker.villageId)}'),
                        Text('Experience: ${worker.experience} years'),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(worker.rating.toString()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _navigateToDetail(context, worker),
                                child: const Text('VIEW DETAILS'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _bookWorker(context, worker, service),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('BOOK NOW'),
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
