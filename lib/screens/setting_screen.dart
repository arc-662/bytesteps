import 'package:image_picker/image_picker.dart';
import 'package:bytesteps/colors.dart';
import 'package:bytesteps/controller.dart';
import 'package:bytesteps/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:io';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final DashboardController controller = Get.find();

  File? profileImage;

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('userBox');

    final String name = userBox.get('name', defaultValue: 'N/A');
    final double weight = userBox.get('weight', defaultValue: 0);
    final double height = userBox.get('height', defaultValue: 0);
    final String gender = userBox.get('gender', defaultValue: 'N/A');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Gradient Header

            const SizedBox(height: 24),

            // User Info Card
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Card(
                    elevation: 6,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: profileImage != null
                                    ? FileImage(profileImage!)
                                    : const AssetImage(
                                            "assets/images/profile.png")
                                        as ImageProvider,
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () async {
                                    await pickImageFromGallery();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                        )
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "abc.SergeyBrin@gmail.com",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Height",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    "$height inches",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Weight",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    "$weight lbs",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Gender",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    gender,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditScreen()),
                              );
                            },
                            icon: const Icon(Icons.edit,
                                size: 18, color: Colors.black),
                            label: const Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellowColor,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Reset Progress Option
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: const Icon(Icons.refresh,
                          color: Color.fromRGBO(13, 71, 161, 1)),
                      title: const Text("Reset Daily Progress",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Warning"),
                            content: const Text(
                                "Are you sure you want to reset your daily progress?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.black)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: lightBlue,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  controller.resetProgress();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Progress has been reset")),
                                  );
                                },
                                child: const Text("Reset",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Step Goal
                  Obx(
                    () => Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const FaIcon(FontAwesomeIcons.crosshairs,
                            color: Color.fromRGBO(13, 71, 161, 1)),
                        title: const Text("Step Goal",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        trailing: SizedBox(
                          width: 100,
                          child: DropdownButton<int>(
                            dropdownColor: Colors.blue[50],
                            isDense: true,
                            underline: const SizedBox(),
                            value: controller.selectedGoal.value,
                            onChanged: (int? newValue) {
                              controller.selectedGoal.value = newValue!;
                            },
                            items: controller.goals.map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text("$value"),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Version Info
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: const ListTile(
                      leading: Icon(Icons.system_update,
                          color: Color.fromRGBO(13, 71, 161, 1)),
                      title: Text("Newer Version Available! 2.03.002",
                          style: TextStyle(fontWeight: FontWeight.w600)),
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
}
