import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../utils/responsive_helper.dart'; // Import
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

  IconData _getCategoryIcon(String name) {
    if (name.contains('Worker')) return Icons.engineering;
    if (name.contains('Home')) return Icons.home_repair_service;
    if (name.contains('Daily')) return Icons.local_shipping;
    if (name.contains('Agriculture')) return Icons.agriculture;
    if (name.contains('Part-time')) return Icons.timer;
    return Icons.category;
  }
  
  Color _getCategoryColor(int index) {
     const colors = [
      Color(0xFFE0E7FF), // Indigo Light
      Color(0xFFFCE7F3), // Pink Light
      Color(0xFFD1FAE5), // Emerald Light
      Color(0xFFFEF3C7), // Amber Light
      Color(0xFFEDE9FE), // Violet Light
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // Max Width for Content to prevent it constantly spanning 4k screens
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Responsive.isDesktop(context) ? AppBar(
        title: const Text('V SEVE'),
        actions: [
          Center(child: Text('Welcome, ${Session.currentUser?.name ?? "Guest"}  ', style: const TextStyle(fontWeight: FontWeight.bold))),
          IconButton(onPressed: () => Navigator.pushNamed(context, '/user_profile'), icon: const Icon(Icons.person_pin)),
        ],
      ) : null, // Mobile has custom header inside body
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200), // Max width for content
            child: Column(
              children: [
                 if (!Responsive.isDesktop(context)) ...[
                    // Mobile Custom Header
                    Padding(
                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                                 const SizedBox(width: 4),
                                 Text(
                                   _villageName.isEmpty ? 'Select Location' : _villageName,
                                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                 ),
                               ],
                             ),
                           ],
                         ),
                         GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/user_profile').then((_) => setState(() {}));
                          },
                           child: CircleAvatar(
                             radius: 18,
                             backgroundColor: AppColors.primary.withOpacity(0.1),
                             child: Text(
                               Session.currentUser?.name?[0] ?? 'U',
                               style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
                 
                 // Sticky Search Bar
                 Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     height: 50,
                     decoration: BoxDecoration(
                       color: Colors.grey[100],
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.grey[300]!),
                     ),
                     child: Row(
                       children: [
                         const Icon(Icons.search, color: Colors.grey),
                         const SizedBox(width: 12),
                         Text(
                           'Search for services...',
                           style: TextStyle(color: Colors.grey[500], fontSize: 16),
                         ),
                       ],
                     ),
                   ),
                 ),
                 
                 // Content
                 Expanded(
                   child: SingleChildScrollView(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // Banners
                         SizedBox(
                           height: 160,
                           child: ListView(
                             scrollDirection: Axis.horizontal,
                             children: [
                               _buildBanner(
                                 Colors.black87, 
                                 'Get 50% Off\nOn First Booking', 
                                 'Use Code: NEW50',
                                 Icons.local_offer,
                                 width: Responsive.isDesktop(context) ? 400 : 280
                               ),
                               const SizedBox(width: 16),
                               _buildBanner(
                                 AppColors.secondary, 
                                 'Quick Home\nCleaning', 
                                 'Starts @ ₹499',
                                 Icons.cleaning_services,
                                 width: Responsive.isDesktop(context) ? 400 : 280
                               ),
                             ],
                           ),
                         ),
                         const SizedBox(height: 24),
                         
                         // Categories
                         const Text(
                           'All Services',
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                         ),
                         const SizedBox(height: 16),
                         
                         GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isMobile(context) ? 3 : 6, // 3 for Mobile, 6 for Web
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 24,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: mockCategories.length,
                            itemBuilder: (context, index) {
                              final category = mockCategories[index];
                              final color = _getCategoryColor(index);
                              
                              return InkWell(
                                onTap: () => _navigateToServiceList(category.id, category.name),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(category.name),
                                        color: AppColors.textPrimary,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12, 
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                         ),
                         const SizedBox(height: 32),
                       ],
                     ),
                   ),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(Color color, String title, String subtitle, IconData icon, {double width = 280}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: Colors.white.withOpacity(0.3), size: 60),
        ],
      ),
    );
  }
}
