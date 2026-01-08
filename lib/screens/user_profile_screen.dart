import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../utils/language.dart';
import '../models/user.dart';
import '../mock_data/villages.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  
  void _logout() {
    Session.currentUser = null;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _toggleLanguage() {
    setState(() {
      Language.toggleLanguage();
    });
    // Find ancestor to rebuild app if needed, or just set string.
    // For this simple app, setState here rebuilds this screen.
    // Global rebuild might be needed for other screens if not reloaded.
    // But since we navigate back, main screens might need to listen.
    // For now, this toggles the singleton.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to ${Language.currentLanguage}')),
    );
  }

  String _getVillageName() {
    if (Session.currentUser != null && Session.currentUser is User) {
       final villageId = (Session.currentUser as User).villageId;
       return mockVillages.firstWhere((v) => v.id == villageId).name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                   CircleAvatar(
                     radius: 50,
                     backgroundColor: Colors.white,
                     child: Text(
                       user?.name?[0] ?? 'U',
                       style: const TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.bold),
                     ),
                   ),
                   const SizedBox(height: 16),
                   Text(
                     user?.name ?? 'Guest',
                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                   ),
                   const SizedBox(height: 8),
                   if (user is User)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getVillageName(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings List
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.language,
                    title: 'Change Language',
                    subtitle: Language.currentLanguage == 'en' ? 'English' : 'Tamil',
                    onTap: _toggleLanguage,
                    trailing: const Icon(Icons.swap_horiz, color: AppColors.primary),
                  ),
                  _buildSettingsTile(
                    icon: Icons.phone,
                    title: 'Phone Number',
                    subtitle: user?.phone ?? '',
                    onTap: () {}, // No action
                  ),
                  _buildSettingsTile(
                    icon: Icons.history,
                    title: 'My Bookings',
                    subtitle: 'View past service requests',
                    onTap: () {
                       // Future: Navigate to booking history
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking History coming soon!')));
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('LOGOUT'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
