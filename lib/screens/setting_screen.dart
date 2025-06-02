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
                    color: whiteColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              // Profile Image
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: profileImage != null
                                    ? FileImage(profileImage!)
                                    : AssetImage("assets/images/profile.png")
                                        as ImageProvider,
                              ),

                              // Edit Icon (bottom right)
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () async {
                                    await pickImageFromGallery();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text("abc.SergeyBrin@gmail.com",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Height: $height in",
                                  style: const TextStyle(fontSize: 14)),
                              Text("Weight: $weight lbs",
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Gender: $gender",
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellowColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text("Edit Profile",
                                style: TextStyle(color: Colors.black)),
                          )
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
