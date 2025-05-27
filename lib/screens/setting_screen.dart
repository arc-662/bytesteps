import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          //User Info Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.lightBlue[100],
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        maxRadius: 40.0,
                        child: Image.asset("assets/images/profile.png"),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text("abc.Sergey Brin@gmail.com")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Height: $height",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text("Weight: $weight",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(gender,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            autofocus: true,
                            style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.amberAccent),
                            onPressed: () {},
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // Reset Progress Option
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              color: Colors.lightBlue[100],
              child: ListTile(
                leading: Icon(Icons.refresh,
                    color: const Color.fromRGBO(13, 71, 161, 1)),
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
          // step goals
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
                color: Colors.lightBlue[100],
                child: Obx(
                  () => ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.crosshairs,
                      color: Color.fromRGBO(13, 71, 161, 1),
                    ),
                    title: const Text(
                      "Step Goal",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: SizedBox(
                      width: 100, // Adjust width as needed
                      child: DropdownButton<int>(
                        dropdownColor: Colors.blue[50],
                        isDense: true,
                        underline:
                            const SizedBox(), // Removes the default underline
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
                )),
          ),
          //  Version Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              color: Colors.lightBlue[100],
              child: ListTile(
                leading: Icon(
                  Icons.system_update,
                  color: Color.fromRGBO(13, 71, 161, 1),
                ),
                title: Text(
                  "Newer Version Available! 2.03.002",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
