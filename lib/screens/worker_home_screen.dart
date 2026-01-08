import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../mock_data/service_requests.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.get('worker')),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          const Text(
            'My Jobs',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          ...mockServiceRequests.map((request) => Card(
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
                        'Order #${request.id}',
                        style: AppTextStyles.subHeading,
                      ),
                      Chip(
                        label: Text(
                          request.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: request.status == 'completed' 
                            ? Colors.green 
                            : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Date: ${request.createdAt.toString().split('.')[0]}'),
                  if (request.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Notes: ${request.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
