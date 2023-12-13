import 'package:flutter/material.dart';
import 'package:pills/pages/confirmation.dart';
import 'package:pills/pages/drug_editor.dart';
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
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Дед пей таблетки"),
        actions: [
          ElevatedButton(
            onPressed: scheduler.schedule,
            child: Text("Sched!"),
          ),
          ElevatedButton(
            onPressed: () {
              const dbgDrugName = '__dbg__';
              late final Drug drug;
              try {
                drug = drugRepo
                    .getDrugs()
                    .firstWhere((element) => element.name == dbgDrugName);
              } on StateError {
                drug = Drug(name: dbgDrugName);
                drugRepo.addDrug(drug);
              }
              final t = DateTime.now().add(Duration(minutes: 1));

              drug.consumptionDays = [
                for (int i = 0; i < 7; i++) i == (t.weekday - 1)
              ];
              drug.consumptionTimes = [t.minute + t.hour * 60];

              drugRepo.saveDrug(drug);
            },
            child: const Text("Dbg!"),
          ),
        ],
      ),
      body: StreamBuilder<Map<int, Drug>>(
        initialData: const {},
        stream: drugRepo.stream,
        builder: (context, snapshot) {
          final sortedVals = snapshot.data!.values.toList();
          sortedVals.sort((a, b) => a.id - b.id);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: sortedVals
                      .map((e) => ListTile(
                            title: Text(e.name),
                            onTap: () async {
                              final drug = await Navigator.of(context)
                                  .push(DrugEditorRoute("Edit drug", drug: e));
                              if (drug != null) {
                                drugRepo.saveDrug(drug);
                              }
                            },
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder(
                stream: scheduler.prevEntryStream,
                builder: (context, snapshot) {
                  return TimerBuilder.periodic(
                    Duration(seconds: 3),
                    builder: (context) {
                      if (!snapshot.hasData) return SizedBox.shrink();
                      final data = snapshot.data!;
                      if(DateTime.now().difference(data.time) > Duration(minutes: 15)) return SizedBox.shrink();
                      return InkWell(
                        onTap: (){
                          // TODO: debug here
                          Navigator.of(context).push(ConfirmationPageRoute(data.drug.id, false));
                        },
                        child: Container(
                          color: Colors.red,
                          child: Center(
                            child: Text('Выпить ${data.drug.name}'),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addDrug(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void addDrug(BuildContext context) async {
    final drug = await Navigator.of(context).push(DrugEditorRoute("Add drug"));
    if (drug != null) {
      drugRepo.addDrug(drug);
    }
  }
}
