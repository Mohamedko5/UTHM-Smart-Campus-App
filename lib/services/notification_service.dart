import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:uthm_smart_campus/models/reminder_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    await _configureLocalTimeZone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _notifications.initialize(settings: settings);
    await requestPermissions();
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();

    try {
      await androidImplementation?.requestExactAlarmsPermission();
    } on PlatformException catch (error) {
      debugPrint('Exact alarm permission request skipped: ${error.message}');
    }

    final iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    final macImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();
    await macImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> scheduleReminder(ReminderModel reminder) async {
    await initialize();

    if (reminder.scheduledAt.isBefore(DateTime.now())) {
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'academic_reminders',
        'Academic reminders',
        channelDescription:
            'Notifications for quizzes, surveys, study sessions, and custom reminders.',
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final scheduledDate = tz.TZDateTime.from(reminder.scheduledAt, tz.local);

    try {
      await _notifications.zonedSchedule(
        id: reminder.id,
        title: reminder.title,
        body: reminder.description,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: reminder.type.name,
      );
    } on PlatformException catch (error) {
      debugPrint('Exact reminder scheduling failed: ${error.message}');
      await _notifications.zonedSchedule(
        id: reminder.id,
        title: reminder.title,
        body: reminder.description,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: reminder.type.name,
      );
    }
  }

  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      final timeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone.identifier));
    } on Object catch (error) {
      debugPrint('Could not detect local timezone: $error');
      tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));
    }
  }
}
