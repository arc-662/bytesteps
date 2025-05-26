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
      appBar: AppBar(title: Text('User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name')),
            TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight (lbs)'),
                keyboardType: TextInputType.number),
            TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height (inches)'),
                keyboardType: TextInputType.number),
            DropdownButton<String>(
              hint: Text('Select Gender'),
              value: gender,
              onChanged: (value) => setState(() => gender = value!),
              items: ['Male', 'Female', 'Other']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveUserData, child: Text('Continue')),
          ],
        ),
      ),
    );
  }
}
