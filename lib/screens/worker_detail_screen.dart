import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../models/worker.dart';
import '../models/service.dart';
import '../models/service_request.dart'; // Import for ServiceRequest
import '../models/village.dart';
import '../mock_data/villages.dart';
import '../mock_data/service_requests.dart'; // Import for addServiceRequest and mock list

class WorkerDetailScreen extends StatefulWidget {
  const WorkerDetailScreen({super.key});

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  
  String _getVillageName(String villageId) {
    return mockVillages
        .firstWhere((v) => v.id == villageId, orElse: () => Village(id: '', name: 'Unknown', district: ''))
        .name;
  }

  // Reuse logic from WorkerList
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

  void _navigateToTracking(BuildContext context, ServiceRequest request) {
    Navigator.pushNamed(
      context,
      '/tracking',
      arguments: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final worker = args['worker'] as Worker;
    final service = args['service'] as Service;
    
    final existingRequest = _getExistingRequest(worker.id, service.id);

    return Scaffold(
      appBar: AppBar(title: Text(worker.name)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          
          // Fixed Bottom Bar for Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: existingRequest != null
                    ? (existingRequest.status == 'accepted' 
                        ? ElevatedButton(
                            onPressed: () => _navigateToTracking(context, existingRequest),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('TRACK WORKER'),
                          )
                        : ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.grey[300],
                               padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('REQUEST SENT'),
                          ))
                    : ElevatedButton(
                        onPressed: () => _bookWorker(context, worker, service),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('BOOK NOW'),
                      ),
              ),
            ),
          ),
        ],
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
