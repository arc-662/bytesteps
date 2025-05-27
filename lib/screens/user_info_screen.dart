// ignore_for_file: use_build_context_synchronously

import 'package:bytesteps/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String gender = 'Male';

  void saveUserData() async {
    final name = nameController.text.trim();
    final weight = double.tryParse(weightController.text.trim());
    final height = double.tryParse(heightController.text.trim());

    if (name.isEmpty || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid information.')),
      );
      return;
    }

    final box = Hive.box('userBox');
    await box.put('name', name);
    await box.put('weight', weight);
    await box.put('height', height);
    await box.put('gender', gender);
    await box.put('isUserInfoSaved', true);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade100,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Your Information',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (lbs)',
                    prefixIcon: Icon(Icons.fitness_center),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (inches)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select Gender'),
                      value: gender,
                      onChanged: (value) => setState(() => gender = value!),
                      items: ['Male', 'Female', 'Other']
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: saveUserData,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
