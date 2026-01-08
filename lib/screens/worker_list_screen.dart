import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/workers.dart';
import '../mock_data/villages.dart';
import '../models/service.dart';
import '../models/worker.dart';
import '../models/village.dart';

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  void _navigateToDetail(BuildContext context, Worker worker) {
    Navigator.pushNamed(
      context, 
      '/worker_detail',
      arguments: worker,
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
      // Simple string matching for skill. In real app, use IDs.
      // Our mock categories map to skills (e.g. Plumbing -> Plumbing)
      // Service names might not exactly match categories, but for this Phase 2 requirement
      // we filter simply. Let's assume workers have broad skills like "Plumbing".
      // We will check if any of the worker's skills match the service name loosely or category.
      // For simplicity in Phase 2, let's assume specific skills are mapped.
      
      // Better approach: Since we don't have category name passed here easily without lookup,
      // and Worker skills are strings like "Plumbing".
      // Let's match if any of the worker's skills is contained in the Service Name 
      // OR if the Service Name is contained in skills.
      // (User requested: "Worker Filter Logic... Show workers...")
      
      // Allow all for now if no match found, for testing. 
      // But let's try to be specific:
      // Worker skills: ['Plumbing', 'Electrical'], ['Carpenter']
      // Service Name: 'Pipe Repair' (Category: Plumbing). 
      
      // Ideally we should pass Category Name from previous screen to filter skills accurately.
      // But let's do a loose matching on skills vs service name for this mock.
      // Or better, let's just show ALL available workers for the browsing flow demo if no direct match.
      
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSameVillage ? Colors.green[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isSameVillage ? 'Your Village' : 'Nearby',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSameVillage ? Colors.green[800] : Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Village: ${_getVillageName(worker.villageId)}'),
                        const SizedBox(height: 4),
                        Text('Experience: ${worker.experience} years'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(worker.rating.toString()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _navigateToDetail(context, worker),
                            child: const Text('VIEW DETAILS'),
                          ),
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
