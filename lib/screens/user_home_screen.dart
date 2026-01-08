import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../mock_data/services.dart';
import '../mock_data/categories.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.get('user')),
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
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            Language.get('services'),
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          ...mockServices.map((service) => Card(
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
