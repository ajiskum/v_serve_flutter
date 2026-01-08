import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  void _toggleLanguage() {
    setState(() {
      Language.toggleLanguage();
    });
  }

  void _navigateToRole(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.get('app_name')),
        actions: [
          TextButton(
            onPressed: _toggleLanguage,
            child: Text(
              Language.get('switch_language'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Language.get('select_role'),
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _RoleCard(
              title: Language.get('user'),
              icon: Icons.person,
              color: Colors.blue,
              onTap: () => _navigateToRole(context, '/user_home'),
            ),
            const SizedBox(height: 20),
            _RoleCard(
              title: Language.get('worker'),
              icon: Icons.engineering,
              color: Colors.orange,
              onTap: () => _navigateToRole(context, '/worker_home'),
            ),
            const SizedBox(height: 20),
            _RoleCard(
              title: Language.get('admin'),
              icon: Icons.admin_panel_settings,
              color: Colors.red,
              onTap: () => _navigateToRole(context, '/admin_home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 24),
              Text(
                title,
                style: AppTextStyles.subHeading,
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
