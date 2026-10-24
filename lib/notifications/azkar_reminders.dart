import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Daily morning/evening reminder notifications. Default timezone is Addis Ababa;
/// change the location if the app is distributed for another region.
class AzkarReminders {
  AzkarReminders._();
  static final AzkarReminders instance = AzkarReminders._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Addis_Ababa'));
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool?> requestPermission() async {
    await initialize();
    return _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDaily({required int id, required int hour, required int minute,
    required String title, required String body}) async {
    await initialize();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) scheduled = scheduled.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      id, title, body, scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_azkar_reminders', 'የአዝካር ማስታወሻ',
          channelDescription: 'የጠዋትና የማታ አዝካር ማስታወሻዎች',
          importance: Importance.max, priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  Future<void> configure({required bool enabled, required int morningHour,
    required int morningMinute, required int eveningHour, required int eveningMinute}) async {
    await initialize();
    await cancelAll();
    if (!enabled) return;
    await scheduleDaily(id: 1, hour: morningHour, minute: morningMinute,
      title: 'Daily Azkar ☀️', body: 'የጠዋት አዝካር ማለትዎን አይርሱ');
    await scheduleDaily(id: 2, hour: eveningHour, minute: eveningMinute,
      title: 'Daily Azkar 🌙', body: 'የማታ አዝካር ማለትዎን አይርሱ');
  }
}
