import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  final DashboardController controller = Get.find();

  SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView(
        children: [
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
                          onPressed: () => Navigator.pop(context), // cancel
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            controller.resetProgress(); // Call reset
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Progress has been reset")),
                            );
                          },
                          child: Text(
                            "Reset",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
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
