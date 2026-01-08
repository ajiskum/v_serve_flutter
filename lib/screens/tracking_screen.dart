import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/service_request.dart';
import '../models/worker.dart';
import '../mock_data/workers.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  Worker _getWorker(String workerId) {
    return mockWorkers.firstWhere(
      (w) => w.id == workerId,
      orElse: () => Worker(id: '', name: 'Unknown', phone: '', villageId: '', skills: [], isAvailable: false, rating: 0, completedJobs: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = ModalRoute.of(context)!.settings.arguments as ServiceRequest;
    final worker = _getWorker(request.workerId);

    int currentStep = 0;
    if (request.status == 'pending') currentStep = 1;
    if (request.status == 'accepted') currentStep = 2;
    if (request.status == 'completed') currentStep = 3; 
    // "On the Way" could be an intermediate status if we had it. 
    // For now, Accepted -> Completed. Let's assume 'accepted' covers 'on the way'.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Track Service', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 1. Map Placeholder
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.map, size: 100, color: Colors.grey[300]),
                const Text('Live Map Tracking', style: TextStyle(color: Colors.grey)),
                // Mock Worker Pin
                Align(
                  alignment: const Alignment(0.2, 0.2),
                  child: Icon(Icons.location_on, color: AppColors.primary, size: 40),
                ),
                // Mock User Home
                Align(
                  alignment: const Alignment(-0.2, -0.2),
                  child: Icon(Icons.home, color: Colors.green, size: 40),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                   BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Worker Profile tracking strip
                   Row(
                     children: [
                       CircleAvatar(
                         radius: 28,
                         backgroundColor: AppColors.secondary.withOpacity(0.1),
                         child: Text(worker.name[0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(worker.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                             const Text('Verifed Partner', style: TextStyle(color: Colors.grey)),
                           ],
                         ),
                       ),
                       Container(
                         decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),
                         child: IconButton(
                           icon: const Icon(Icons.call, color: Colors.white),
                           onPressed: () {},
                         ),
                       )
                     ],
                   ),
                   const Divider(height: 32),
                   
                   // Stepper
                   Expanded(
                     child: ListView(
                       children: [
                         _buildStep(
                           title: 'Request Sent', 
                           subtitle: 'Waiting for confirmation', 
                           isActive: currentStep >= 1,
                           isLast: false
                         ),
                         _buildStep(
                           title: 'Request Accepted', 
                           subtitle: '${worker.name} has accepted your job', 
                           isActive: currentStep >= 2,
                           isLast: false
                         ),
                         _buildStep(
                           title: 'On The Way', 
                           subtitle: '${worker.name} is reaching your location', 
                           isActive: currentStep >= 2, // Mocking "On Way" as part of Accepted
                           isLast: false
                         ),
                          _buildStep(
                           title: 'Arrived / Completed', 
                           subtitle: 'Service in progress or done', 
                           isActive: currentStep >= 3,
                           isLast: true
                         ),
                       ],
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required String title, required String subtitle, required bool isActive, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActive ? Colors.green : Colors.grey,
            ),
            if (!isLast)
              Container(
                height: 40,
                width: 2,
                color: isActive ? Colors.green : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: isActive ? Colors.black : Colors.grey
                )
              ),
              Text(
                subtitle, 
                style: const TextStyle(fontSize: 12, color: Colors.grey)
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
