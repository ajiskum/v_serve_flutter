import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../mock_data/services.dart';
import '../models/service.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  void _navigateToWorkerList(BuildContext context, Service service) {
    Navigator.pushNamed(
      context, 
      '/worker_list',
      arguments: service,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final categoryId = args['categoryId']!;
    final categoryName = args['categoryName']!;

    final services = mockServices.where((s) => s.categoryId == categoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: services.isEmpty 
          ? const Center(child: Text('No services found'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(service.name, style: AppTextStyles.subHeading),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(service.description),
                        const SizedBox(height: 8),
                        Text(
                          '₹${service.price}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _navigateToWorkerList(context, service),
                  ),
                );
              },
            ),
    );
  }
}
