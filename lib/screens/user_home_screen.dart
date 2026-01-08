import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/services.dart';
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
            Text(Language.get('user')),
            if (Session.currentUser != null)
              Text(
                '${Session.currentUser.name} • $_villageName',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          Text(
            Language.get('categories'),
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                return Card(
                  margin: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () => _navigateToServiceList(category.id, category.name),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.category, size: 32, color: AppColors.primary),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular Services',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          ...mockServices.take(3).map((service) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(service.name[0]),
              ),
              title: Text(service.name),
              subtitle: Text(service.description),
              trailing: Text(
                '₹${service.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
