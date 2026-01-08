import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/categories.dart';
import '../mock_data/villages.dart';
import '../models/village.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String get _villageName {
    if (Session.currentUser != null) {
      final villageId = Session.currentUser.villageId;
      final village = mockVillages.firstWhere(
        (v) => v.id == villageId,
        orElse: () => Village(id: '', name: 'Unknown', district: ''),
      );
      return village.name;
    }
    return '';
  }

  void _navigateToServiceList(String categoryId, String categoryName) {
    Navigator.pushNamed(
      context, 
      '/service_list',
      arguments: {'categoryId': categoryId, 'categoryName': categoryName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Session.currentUser != null) ...[
              Text(
                'Hello, ${Session.currentUser.name}',
                 style: const TextStyle(fontSize: 18),
              ),
              Text(
                '📍 $_villageName',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ] else ...[
               Text(Language.get('user')),
            ]
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          const Text(
            'Service Categories',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          // Changed to Vertical List of Cards for better visibility of 5 main categories
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockCategories.length,
            itemBuilder: (context, index) {
              final category = mockCategories[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => _navigateToServiceList(category.id, category.name),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Placeholder for Icon if asset not available, else use IconData
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.handyman, color: AppColors.primary), // Default icon
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            category.name,
                            style: AppTextStyles.subHeading,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
