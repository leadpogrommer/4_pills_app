import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mutex/mutex.dart';
import 'package:pills/main.dart';
import 'package:pills/repo/drug_repo.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/drug.dart';

class ScheduleEntry implements Comparable<ScheduleEntry> {
  final DateTime time;
  final Drug drug;
  final bool isPast;

  ScheduleEntry(this.time, this.drug, this.isPast);

  @override
  int compareTo(ScheduleEntry other) {
    return time.compareTo(other.time);
  }

  @override
  String toString() {
    return "{drug: ${drug.name}, time: ${time.month}.${time.day} ${time.hour}:${time.minute}, past: $isPast}";
  }
}



final scheduler = Scheduler._();
const maxPushCount = 100;

class Scheduler {
  Scheduler._();
  final mutex = Mutex();
  final _prevEntryStreamController = StreamController<ScheduleEntry>();
  late final Stream<ScheduleEntry> prevEntryStream = _prevEntryStreamController.stream.asBroadcastStream();

  // TODO: make this code not suck
  Future<void> schedule() => mutex.protect(() async {
        final timeline = List<ScheduleEntry>.empty(growable: true);

        final drugs = drugRepo.getDrugs();

        for (int deltaDay = -8; deltaDay <= 8; deltaDay++) {
          final currentDay = DateTime.now().add(Duration(days: deltaDay));
          for (final drug in drugs) {
            if (!drug.consumptionDays[currentDay.weekday - 1]) {
              continue;
            }
            for (final drugTime in drug.consumptionTimes) {
              final t = currentDay.copyWith(
                hour: drugTime ~/ 60,
                minute: drugTime % 60,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              );
              timeline.add(ScheduleEntry(
                t,
                drug,
                t.isBefore(DateTime.now()),
              ));
            }
          }
        }
        timeline.sort();
        // print(timeline);
        final nextTake = timeline.firstWhere((element) => !element.isPast);
        final prevTake = timeline.lastWhere((element) => element.isPast);
        print("Prev: $prevTake\nNext: ${nextTake}");
        _setUpAlarms(timeline.where((element) => !element.isPast).toList());
        _prevEntryStreamController.add(prevTake);
      });

  void _setUpAlarms(List<ScheduleEntry> entries) async {
    for (int i = 0; i < maxPushCount; i++) {
      notifs.cancel(i);
    }

    for (int i = 0; i < min(maxPushCount, entries.length); i++) {
      final entry = entries[i];

      _setUpPush(entry, i);
    }
  }

  void _setUpPush(ScheduleEntry entry, int nId) async {
    final isFullScreen = entry.drug.notificationType == NotificationType.call;
    print('Scheduling ${entry.drug.name}, time: ${entry.time}, fs: $isFullScreen');
    notifs.zonedSchedule(
      nId,
      'Время пить ${entry.drug.name}',
      'Нажмите, чтобы открыть окно подтверждения',
      tz.TZDateTime.from(entry.time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'my_cid',
          'Supa improtont chenol',
          priority: Priority.max,
          importance: Importance.max,
          fullScreenIntent: isFullScreen,
          category: AndroidNotificationCategory.alarm,
          silent: false,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: entry.drug.id.toString(),
    );
  }
}
