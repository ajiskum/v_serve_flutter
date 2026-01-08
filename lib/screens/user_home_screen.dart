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

  // Helper to get icon data based on category name
  IconData _getCategoryIcon(String name) {
    if (name.contains('Worker')) return Icons.engineering;
    if (name.contains('Home')) return Icons.home_repair_service;
    if (name.contains('Daily')) return Icons.local_shipping;
    if (name.contains('Agriculture')) return Icons.agriculture;
    if (name.contains('Part-time')) return Icons.timer;
    return Icons.category;
  }
  
  // Helper for gradient colors per category
  List<Color> _getCategoryColors(int index) {
    const gradients = [
      [Color(0xFF6366F1), Color(0xFF4F46E5)], // Indigo
      [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
      [Color(0xFF10B981), Color(0xFF059669)], // Emerald
      [Color(0xFFF59E0B), Color(0xFFD97706)], // Amber
      [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Violet
    ];
    return gradients[index % gradients.length];
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
                 style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    _villageName,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ] else ...[
               Text(Language.get('user')),
            ]
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/user_profile').then((_) => setState(() {}));
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  Session.currentUser?.name?[0] ?? 'U',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Text(
              Language.get('categories'),
              style: AppTextStyles.heading,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                final colors = _getCategoryColors(index);
                
                return InkWell(
                  onTap: () => _navigateToServiceList(category.id, category.name),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(category.name),
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
