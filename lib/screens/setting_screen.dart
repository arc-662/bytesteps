import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingScreen extends StatelessWidget {
  final DashboardController controller = Get.find();

  SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('userBox');

    final String name = userBox.get('name', defaultValue: 'N/A');
    final double weight = userBox.get('weight', defaultValue: 0);
    final double height = userBox.get('height', defaultValue: 0);
    final String gender = userBox.get('gender', defaultValue: 'N/A');

    return Scaffold(
      body: ListView(
        children: [
          // ✅ User Info Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.lightBlue[50],
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("User Info",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900])),
                    ),
                    SizedBox(height: 10),
                    Text("Name: $name", style: TextStyle(fontSize: 16)),
                    Text("Gender: $gender", style: TextStyle(fontSize: 16)),
                    Text("Weight: $weight (In lbs)",
                        style: TextStyle(fontSize: 16)),
                    Text("Height: $height (In Inches)",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),

          // 🔁 Reset Progress Option
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.lightBlue[100],
              child: ListTile(
                leading: Icon(Icons.refresh, color: Colors.blue[900]),
                title: Text(
                  "Reset Daily Progress",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Warning"),
                      content: Text(
                          "Are you sure you want to reset your daily progress?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel",
                              style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            controller.resetProgress();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Progress has been reset")),
                            );
                          },
                          child: Text("Reset",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 🆕 Version Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.system_update),
                title: Text("Newer Version Available! 2.03.002"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
