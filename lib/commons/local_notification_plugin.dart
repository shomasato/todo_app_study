import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifier {
  final FlutterLocalNotificationsPlugin flnp =
      FlutterLocalNotificationsPlugin();

  void initialize() {
    flnp.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('app_icon'),
      ),
    );
  }

  Future<void> setWeeklyNotice(
      int id, String title, int hour, int minutes, int weekday) async {
    initialize();
    //
    //idを曜日毎にユニークにする
    final int noticeId = id + weekday;
    //
    await flnp.zonedSchedule(
      noticeId,
      'Weekstep',
      title,
      nextInstanceOfWeeklyNotice(hour, minutes, weekday),
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails()),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime nextInstanceOfWeeklyNotice(int hour, int minutes, int weekday) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void cancelNotice() => flnp.cancelAll();
}
