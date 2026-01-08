import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/village.dart';
import '../mock_data/villages.dart';
import '../mock_data/users.dart';
import '../utils/constants.dart';
import '../utils/session.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedVillageId;

  void _register() {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        id: 'u${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        phone: _phoneController.text,
        villageId: _selectedVillageId!,
      );

      addUser(newUser);
      Session.currentUser = newUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful! Logging in...')),
      );

      // Simulate auto-login
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, '/user_home', (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter phone' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedVillageId,
                decoration: const InputDecoration(labelText: 'Select Village', border: OutlineInputBorder()),
                items: mockVillages.map((Village village) {
                  return DropdownMenuItem<String>(
                    value: village.id,
                    child: Text(village.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedVillageId = val),
                validator: (value) => value == null ? 'Select village' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white,
                ),
                child: const Text('REGISTER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
