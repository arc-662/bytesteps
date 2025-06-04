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
  bool isKg = false; // false = lbs, true = kg

  void saveUserData() async {
    final name = nameController.text.trim();
    final weightInput = double.tryParse(weightController.text.trim());
    final height = double.tryParse(heightController.text.trim());

    if (name.isEmpty || weightInput == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid information.')),
      );
      return;
    }

    final weight = isKg ? weightInput * 2.20462 : weightInput; // Convert to lbs

    final box = Hive.box('userBox');
    await box.put('name', name);
    await box.put('weight', weight);
    await box.put('height', height);
    await box.put('gender', gender);
    await box.put('isUserInfoSaved', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 80, left: 24, right: 24, bottom: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Welcome To ByteSteps',
                    style: TextStyle(color: Colors.white70, fontSize: 17)),
                Text("One-Time Login",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Form Container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weight input with toggle
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: weightController,
                            decoration: InputDecoration(
                              labelText: 'Weight (${isKg ? "kg" : "lbs"})',
                              prefixIcon: const Icon(Icons.fitness_center),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(20),
                            isSelected: [isKg, !isKg],
                            onPressed: (index) {
                              setState(() {
                                isKg = index == 0;
                              });
                            },
                            selectedColor: Colors.black,
                            fillColor: Colors.white,
                            color: Colors.white,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 36),
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("kg"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("lbs"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: heightController,
                      decoration: const InputDecoration(
                        labelText: 'Height (inches)',
                        prefixIcon: Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: gender,
                          onChanged: (value) => setState(() => gender = value!),
                          items: ['Male', 'Female', 'Other']
                              .map((g) =>
                                  DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
