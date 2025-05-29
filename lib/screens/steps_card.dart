import 'dart:async';

import 'package:bytesteps/colors.dart';
import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'progress_ring_bar.dart';

class DashboardCard extends StatefulWidget {
  const DashboardCard({super.key});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  Stopwatch sw = Stopwatch();
  final DashboardController controller = Get.find();
  Timer? timer;
  // To Start Timer
  void toggleTimer() {
    if (sw.isRunning) {
      sw.stop();
      timer?.cancel();

      // Update time one last time when paused
      final elapsed = sw.elapsed;
      final hours = elapsed.inHours;
      final minutes = elapsed.inMinutes.remainder(60);
      final seconds = elapsed.inSeconds.remainder(60);

      controller.elapsedTime.value = "${hours}h ${minutes}m ${seconds}s";
    } else {
      sw.start();
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        final elapsed = sw.elapsed;
        final hours = elapsed.inHours;
        final minutes = elapsed.inMinutes.remainder(60);
        final seconds = elapsed.inSeconds.remainder(60);

        controller.elapsedTime.value = "${hours}h ${minutes}m ${seconds}s";
      });
    }
  }

  // Request Permission Once
  void requestPermissions() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
  }

  // Late is used to initialize value to variable before it's been called
  late Stream<StepCount> _stepCountStream;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    initPedometer();
    Get.put(DashboardController());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError((error) {
      print('Step Count Error: $error');
    });
  }

  void onStepCount(StepCount event) {
    // Save the base step count only once when the app starts

    if (controller.baseStepCount.value == 0) {
      controller.baseStepCount.value = event.steps;
    }

    // Calculate session steps
    int sessionSteps = event.steps - controller.baseStepCount.value;

    // Update controller values
    controller.stepCount.value = sessionSteps;
    controller.updateDistance();

    controller.progress.value =
        (sessionSteps / controller.selectedGoal.value).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
            color: lightBlue, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "Step Goal: ${controller.selectedGoal.value}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white),
                      ),
                    ),
                  ],
                )),
            // 1st Row to show steps, button and ring progress bar
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(alignment: Alignment.center, children: [
                Obx(() => CustomPaint(
                      size: const Size(180, 180),
                      painter: ProgressRingPainter(
                          progress: controller.progress.value),
                    )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                          controller.stepCount.value.toString(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                    const SizedBox(height: 10),
                    Obx(() => ElevatedButton(
                          onPressed: () {
                            controller.isStarted.value =
                                !controller.isStarted.value;
                            toggleTimer();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE0C3FC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                          ),
                          child: Text(
                            controller.isStarted.value ? 'Pause' : 'Start',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        )),
                  ],
                ),
              ])
            ]),
            // 2nd Row to show Rounded Horizontal Progress Bar
            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Obx(() => SizedBox(
            //           width: MediaQuery.of(context).size.width * 0.85,
            //           height: 13,
            //           child: LinearProgressIndicator(
            //             value: controller.hpb.value,
            //             backgroundColor: Colors.grey[300],
            //             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            //           ),
            //         )),
            //   ),
            // ]),
            // 3rd to show Description of Distance Traveled, Calories Burn and Time Spent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => description("assets/images/way.png",
                    controller.distance.value.toStringAsFixed(2), "Miles")),
                Obx(
                  () => description("assets/images/fire.png",
                      controller.calories.value.toStringAsFixed(0), "Calories"),
                ),
                Obx(
                  () => description("assets/images/stopwatch.png",
                      controller.elapsedTime.value, "Time"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget description(String image, String value, String label) {
    return Column(
      children: [
        SizedBox(height: 40, child: Image.asset(image)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 19)),
        Text(label, style: TextStyle(color: Colors.white))
      ],
    );
  }
}
