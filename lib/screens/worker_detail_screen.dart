import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/worker.dart';
import '../mock_data/villages.dart';
import '../models/village.dart';

class WorkerDetailScreen extends StatelessWidget {
  const WorkerDetailScreen({super.key});

  String _getVillageName(String villageId) {
    return mockVillages
        .firstWhere((v) => v.id == villageId, orElse: () => Village(id: '', name: 'Unknown', district: ''))
        .name;
  }

  @override
  Widget build(BuildContext context) {
    final worker = ModalRoute.of(context)!.settings.arguments as Worker;

    return Scaffold(
      appBar: AppBar(title: Text(worker.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  worker.name[0],
                  style: const TextStyle(fontSize: 40, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _DetailItem(icon: Icons.person, label: 'Name', value: worker.name),
            _DetailItem(icon: Icons.phone, label: 'Phone', value: worker.phone),
            _DetailItem(icon: Icons.location_on, label: 'Village', value: _getVillageName(worker.villageId)),
            _DetailItem(icon: Icons.work, label: 'Experience', value: '${worker.experience} Years'),
            _DetailItem(icon: Icons.build, label: 'Skills', value: worker.skills.join(', ')),
            _DetailItem(icon: Icons.star, label: 'Rating', value: '${worker.rating} / 5.0'),
            _DetailItem(icon: Icons.check_circle, label: 'Completed Jobs', value: '${worker.completedJobs}'),
            
            const SizedBox(height: 40),
            // Placeholder for future Booking Phase
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null, // Disabled for Phase 2
                style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('BOOK NOW (Coming Soon)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
