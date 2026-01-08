import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      
      if (phone.length != 10) {
        setState(() {
          _errorMessage = 'Phone number must be 10 digits';
        });
        return;
      }
      
      bool exists = false;
      if (mockAdmins.any((a) => a.phone == phone)) exists = true;
      if (!exists && mockUsers.any((u) => u.phone == phone)) exists = true;
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
    if (otp.length != 6) {
       setState(() {
        _errorMessage = 'OTP must be 6 digits';
      });
      return;
    }

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 50),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.handshake, size: 60, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    Language.get('app_name'),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading.copyWith(fontSize: 32, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Village Services at your doorstep',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 48),
                  
                  // Phone Input
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    enabled: !_isOtpSent,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter 10 digit mobile number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter phone number';
                      if (value.length < 10) return 'Enter valid 10 digit number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
            
                  // OTP Input
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isOtpSent ? 80 : 0,
                    child: _isOtpSent ? TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintText: '123456',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.lock),
                         filled: true,
                        fillColor: AppColors.background,
                      ),
                    ) : null,
                  ),
            
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  
                  // Main Button
                  ElevatedButton(
                    onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    child: Text(
                      _isOtpSent ? 'VERIFY & LOGIN' : 'SEND OTP',
                      style: AppTextStyles.button,
                    ),
                  ),
                  
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
            
                  const SizedBox(height: 48),
                  
                  // Registration Section
                  const Row(
                    children: [
                       Expanded(child: Divider()),
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 16),
                         child: Text("NEW USER?", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                       ),
                       Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegistrationScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('User Register'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkerRegistrationScreen()));
                          },
                           style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                             side: const BorderSide(color: AppColors.secondary),
                             foregroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Worker Register'),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 20),
                   TextButton.icon(
                      onPressed: _toggleLanguage,
                      icon: const Icon(Icons.language),
                      label: Text(Language.get('switch_language')),
                   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
