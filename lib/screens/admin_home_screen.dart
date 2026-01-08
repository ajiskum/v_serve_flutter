import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../mock_data/users.dart';
import '../mock_data/villages.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.get('admin')),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          const Text(
            'User Statistics',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Users',
                  value: mockUsers.length.toString(),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Villages',
                  value: mockVillages.length.toString(),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Users',
            style: AppTextStyles.subHeading,
          ),
          const SizedBox(height: 16),
          ...mockUsers.map((user) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(user.name[0])),
              title: Text(user.name),
              subtitle: Text(user.phone),
              trailing: const Icon(Icons.more_vert),
            ),
          )).toList(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
