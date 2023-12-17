import 'package:flutter/material.dart';
import 'package:pills/pages/confirmation.dart';
import 'package:pills/pages/drug_editor.dart';
import 'package:pills/pages/drug_list.dart';
import 'package:pills/pages/schedule.dart';
import 'package:pills/repo/consumption_repo.dart';
import 'package:pills/repo/drug_repo.dart';
import 'package:pills/service/sheduler.dart';
import 'package:pills/util/keyguard.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/drug.dart';

final notifs = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  final andr = await notifs.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!;
  await andr.requestNotificationsPermission();
  await andr.requestExactAlarmsPermission();

  // TODO: onDidReceiveBackgroundNotificationResponse
  await notifs.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ), onDidReceiveNotificationResponse: (NotificationResponse resp) async {
    // TODO: do not ignore nulls
    navigatorKey.currentState!.push(ConfirmationPageRoute(
        int.parse(resp.payload!), await isKeyguardLocked()));
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initNotifications();

  await drugRepo.init();
  await consumptionRepo.init();
  scheduler.schedule();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill&Wheels',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SchedulePage(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
