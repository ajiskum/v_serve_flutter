import 'package:flutter/material.dart';
import '../mock_data/admins.dart';
import '../mock_data/users.dart';
import '../mock_data/workers.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import 'user_registration_screen.dart';
import 'worker_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isOtpSent = false;
  String _errorMessage = '';

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      
      // Check if phone exists in any list
      bool exists = false;
      
      // Check Admins
      if (mockAdmins.any((a) => a.phone == phone)) exists = true;
      // Check Users
      if (!exists && mockUsers.any((u) => u.phone == phone)) exists = true;
      // Check Workers
      if (!exists && mockWorkers.any((w) => w.phone == phone)) exists = true;

      if (!exists) {
        setState(() {
          _errorMessage = 'Phone number not registered. Please register below.';
        });
        return;
      }

      setState(() {
        _errorMessage = '';
        _isOtpSent = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Sent! (Use 123456)')),
      );
    }
  }

  void _verifyOtp() {
    final otp = _otpController.text.trim();
    if (otp == '123456') {
      _login();
    } else {
      setState(() {
        _errorMessage = 'Invalid OTP. Please enter 123456';
      });
    }
  }

  void _login() {
    final phone = _phoneController.text.trim();

    for (var admin in mockAdmins) {
      if (admin.phone == phone) {
          Session.currentUser = admin;
          Navigator.pushNamedAndRemoveUntil(context, '/admin_home', (route) => false);
          return;
      }
    }

    for (var user in mockUsers) {
      if (user.phone == phone) {
          Session.currentUser = user;
          Navigator.pushNamedAndRemoveUntil(context, '/user_home', (route) => false);
          return;
      }
    }

      for (var worker in mockWorkers) {
      if (worker.phone == phone) {
          Session.currentUser = worker;
          Navigator.pushNamedAndRemoveUntil(context, '/worker_home', (route) => false);
          return;
      }
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
              
              // Phone Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: !_isOtpSent,
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
              const SizedBox(height: 16),

              // OTP Input (Visible only after sending)
              if (_isOtpSent)
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
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
              
              // Action Button
              ElevatedButton(
                onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isOtpSent ? 'VERIFY & LOGIN' : 'SEND OTP',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              
              // Edit Phone (if OTP sent)
              if (_isOtpSent)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isOtpSent = false;
                      _errorMessage = '';
                      _otpController.clear();
                    });
                  },
                  child: const Text('Change Phone Number'),
                ),

              const SizedBox(height: 32),
              
              // Registration Links
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
