import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../mock_data/users.dart';
import '../mock_data/workers.dart';
import '../mock_data/admins.dart';
import 'user_registration_screen.dart';
import 'worker_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      
      // Check Admins first
      final admin = mockAdmins.firstWhere(
        (a) => a.phone == phone,
        orElse: () => mockAdmins.firstWhere((a) => a.id == 'not_found', orElse: () => mockAdmins[0]), // Safe fallback logic handled by checks below
      );
      
      // Since firstWhere orElse is tricky with typed lists if not nullable, using a loop or simple where check is safer.
      // Let's iterate simply.
      
      for (var admin in mockAdmins) {
        if (admin.phone == phone) {
           Navigator.pushNamedAndRemoveUntil(context, '/admin_home', (route) => false);
           return;
        }
      }

      for (var user in mockUsers) {
        if (user.phone == phone) {
           Navigator.pushNamedAndRemoveUntil(context, '/user_home', (route) => false);
           return;
        }
      }

       for (var worker in mockWorkers) {
        if (worker.phone == phone) {
           Navigator.pushNamedAndRemoveUntil(context, '/worker_home', (route) => false);
           return;
        }
      }

      setState(() {
        _errorMessage = 'Phone number not registered. Please register below.';
      });
    }
  }

  void _toggleLanguage() {
    setState(() {
      Language.toggleLanguage();
    });
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                Language.get('login'),
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  Language.get('login').toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              const Row(
                children: [
                   Expanded(child: Divider()),
                   Padding(
                     padding: EdgeInsets.symmetric(horizontal: 16),
                     child: Text("OR REGISTER", style: TextStyle(color: Colors.grey),),
                   ),
                   Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserRegistrationScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Register as User'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkerRegistrationScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Register as Worker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
