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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(categoryName, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: services.isEmpty 
          ? const Center(child: Text('No services found'))
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: services.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final service = services[index];
                return InkWell(
                  onTap: () => _navigateToWorkerList(context, service),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name, 
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${service.price}', 
                              style: const TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.description,
                              style: TextStyle(
                                fontSize: 13, 
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                             Row(
                               children: [
                                 Icon(Icons.star, size: 14, color: AppColors.accent),
                                 const SizedBox(width: 4),
                                 const Text('4.8 (100+)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                               ],
                             ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // "Add" Button Visual Mock
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                             // Placeholder image if we had real assets
                             image: NetworkImage('https://via.placeholder.com/80'), 
                             opacity: 0.1, 
                             fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                             Transform.translate(
                               offset: const Offset(0, 10),
                               child: Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(8),
                                   boxShadow: [
                                     BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                                   ],
                                   border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                 ),
                                 child: const Text(
                                   'ADD',
                                   style: TextStyle(
                                     color: AppColors.primary,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 12,
                                   ),
                                 ),
                               ),
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
