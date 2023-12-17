import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

import '../model/drug.dart';
import '../repo/drug_repo.dart';
import '../service/sheduler.dart';
import 'confirmation.dart';
import 'drug_editor.dart';

class DrugListPage extends StatefulWidget {
  const DrugListPage({super.key});

  @override
  State<DrugListPage> createState() => _DrugListPageState();
}

class _DrugListPageState extends State<DrugListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Лекарства"),
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
                    .getItems()
                    .firstWhere((element) => element.name == dbgDrugName);
              } on StateError {
                drug = Drug(name: dbgDrugName);
                drugRepo.addItem(drug);
              }
              final t = DateTime.now().add(Duration(minutes: 1));

              drug.consumptionDays = [
                for (int i = 0; i < 7; i++) i == (t.weekday - 1)
              ];
              drug.consumptionTimes = [t.minute + t.hour * 60];

              drugRepo.saveItem(drug);
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
                    trailing: const Icon(Icons.edit),
                    title: Text(e.name),
                    onTap: () async {
                      final drug = await Navigator.of(context)
                          .push(DrugEditorRoute("Редактировать лекарство", drug: e));
                      if (drug != null) {
                        drugRepo.saveItem(drug);
                      }
                    },
                  ))
                      .toList(),
                ),
              ),
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
    final drug = await Navigator.of(context).push(DrugEditorRoute("Добавить лекарство"));
    if (drug != null) {
      drugRepo.addItem(drug);
    }
  }
}
