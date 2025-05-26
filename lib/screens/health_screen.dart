import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔄 Reactive Badge
              Obx(() {
                int currentSteps = controller.stepCount.value.toInt();
                return BadgeReward(currentSteps: currentSteps);
              }),

              const SizedBox(height: 32),

              const Text(
                "Daily Motivation",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),

              const SizedBox(height: 16),

              // 🔄 Reactive Quote
              Obx(() {
                int steps = controller.stepCount.value.toInt();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    getMotivationalQuote(steps),
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Achievements Section
              const Text(
                "Achievements",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),

              const SizedBox(height: 16),

              // Display achievements
              Obx(() {
                int currentSteps = controller.stepCount.value.toInt();
                return Column(
                  children: [
                    AchievementBadge(
                        steps: currentSteps, type: "Weekly", target: 50000),
                    AchievementBadge(
                        steps: currentSteps, type: "Monthly", target: 200000),
                    AchievementBadge(
                        steps: currentSteps, type: "Streak", target: 7),
                    AchievementBadge(
                        steps: currentSteps, type: "Distance", target: 10000),
                    AchievementBadge(
                        steps: currentSteps, type: "Calories", target: 3500),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String getMotivationalQuote(int steps) {
    if (steps >= 10000) return "You're a superstar! 🌟 Keep it up!";
    if (steps >= 5000) return "Great job! You're halfway there!";
    return "Every step counts! Keep moving!";
  }
}

class BadgeReward extends StatelessWidget {
  final int currentSteps;

  const BadgeReward({super.key, required this.currentSteps});

  String getBadgeForSteps(int steps) {
    if (steps >= 10000) return "Gold Medal 🥇";
    if (steps >= 5000) return "Silver Medal 🥈";
    if (steps >= 1000) return "Bronze Medal 🥉";
    return "Keep Going!";
  }

  @override
  Widget build(BuildContext context) {
    String badgeText = getBadgeForSteps(currentSteps);
    Color badgeColor = currentSteps >= 1000 ? Colors.amber : Colors.grey;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentSteps >= 1000 ? Icons.emoji_events : Icons.lock,
                color: badgeColor,
                size: 36,
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final int steps;
  final String type;
  final int target;

  const AchievementBadge(
      {super.key,
      required this.steps,
      required this.type,
      required this.target});

  @override
  Widget build(BuildContext context) {
    bool achieved = steps >= target;
    String badgeText = achieved
        ? "$type Achievement Unlocked! 🎉"
        : "Reach $target steps for $type Achievement";
    Color badgeColor = achieved ? Colors.green : Colors.grey;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              achieved ? Icons.check_circle : Icons.info,
              color: badgeColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
