import 'package:flutter/material.dart';
import 'package:pills/pages/drug_list.dart';
import 'package:timer_builder/timer_builder.dart';

import '../service/sheduler.dart';
import 'confirmation.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('P&W'),
        actions: [
          IconButton(
            onPressed: () async {
              final newDate = await showDatePicker(
                context: context,
                firstDate: DateTime(2023),
                lastDate: DateTime(2025),
                initialDate: date,
              );
              setState(() {
                date = newDate ?? date;
              });
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DrugListPage())),
      ),
      body: Column(
        children: [
          Text(
              "Расписание приема лекарств на ${date.day}.${date.month}.${date.year}"),
          Expanded(
            // Fuck reactivity
            child: TimerBuilder.periodic(
              Duration(seconds: 1),
              builder: (context) {
                return ListView(
                  children: scheduler
                      .getTimelineForDay(date)
                      .map((e) => ListTile(
                            title: Text(e.drug.name),
                            leading: e.isPast
                                ? (e.isConsumed()
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ))
                                : null,
                    subtitle: Text(TimeOfDay.fromDateTime(e.time).format(context)),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          TimerBuilder.periodic(
            Duration(seconds: 3),
            builder: (context) {
              final timeline = scheduler.generateTimeline(DateTime.now());
              final fb = SizedBox.shrink();
              if (timeline.isEmpty) return fb;
              final prevTake = timeline.lastWhere((element) => element.isPast);
              if (DateTime.now().difference(prevTake.time) >
                  Duration(minutes: 15)) return fb;
              if (prevTake.isConsumed()) return fb;
              return InkWell(
                onTap: () {
                  // TODO: debug here
                  Navigator.of(context)
                      .push(ConfirmationPageRoute(prevTake.drug.id, false));
                },
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text('Принять ${prevTake.drug.name}'),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
