import 'package:flutter/material.dart';
import '../models/worker.dart';
import '../models/village.dart';
import '../mock_data/villages.dart';
import '../mock_data/workers.dart';
import '../mock_data/categories.dart';
import '../utils/constants.dart';
import '../utils/session.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() => _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _selectedVillageId;
  final List<String> _selectedSkills = [];

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one service')),
        );
        return;
      }

      final newWorker = Worker(
        id: 'w${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        phone: _phoneController.text,
        villageId: _selectedVillageId!,
        skills: _selectedSkills,
        experience: int.tryParse(_experienceController.text) ?? 0,
        isAvailable: true, // Auto-verified for mock
      );

      addWorker(newWorker);
      Session.currentUser = newWorker;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful! Logging in...')),
      );

      // Simulate auto-login
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, '/worker_home', (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Registration')),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Experience (Years)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter experience' : null,
              ),
              const SizedBox(height: 24),
              const Text('Select Services Offered:', style: AppTextStyles.subHeading),
              const SizedBox(height: 8),
              ...mockCategories.map((category) {
                return CheckboxListTile(
                  title: Text(category.name),
                  value: _selectedSkills.contains(category.name),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedSkills.add(category.name);
                      } else {
                        _selectedSkills.remove(category.name);
                      }
                    });
                  },
                );
              }).toList(),
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
