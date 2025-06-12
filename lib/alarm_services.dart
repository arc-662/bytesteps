import 'package:flutter/services.dart';

class AlarmPermission {
  static const MethodChannel _channel = MethodChannel('alarm_channel');

  /// Checks if the app can schedule exact alarms
  static Future<bool> canScheduleExactAlarms() async {
    final bool result = await _channel.invokeMethod('canScheduleExactAlarms');
    return result;
  }

  /// Requests the exact alarm permission from the user (opens settings screen)
  static Future<void> requestExactAlarmPermission() async {
    await _channel.invokeMethod('requestExactAlarmPermission');
  }
}
