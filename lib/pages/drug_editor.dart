import 'package:flutter/material.dart';
import 'package:pills/model/drug.dart';

class DrugEditorRoute extends MaterialPageRoute<Drug> {
  DrugEditorRoute(String title, {Drug? drug})
      : super(
          builder: (context) {
            return DrugEditor(
              title: title,
              drug: drug,
            );
          },
        );
}

class DrugEditor extends StatefulWidget {
  final String title;
  final Drug? drug;

  const DrugEditor({Key? key, required this.title, this.drug})
      : super(key: key);

  @override
  State<DrugEditor> createState() => _DrugEditorState();
}

class _DrugEditorState extends State<DrugEditor> {
  late Drug drug;
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _methodController;
  static const days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];

  @override
  void initState() {
    super.initState();
    drug = widget.drug != null ? widget.drug!.reallyCopy() : Drug();
    _nameController = TextEditingController(text: drug.name);
    _notesController = TextEditingController(text: drug.notes);
    _methodController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, drug),
            child: const Text("Done"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Название",
                border: OutlineInputBorder(),
              ),
              onChanged: (t) {
                drug.name = t;
              },
              controller: _nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Способ применения",
                border: OutlineInputBorder(),
              ),
              onChanged: (t) {
                drug.notes = t;
              },
              controller: _notesController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownMenu<NotificationType>(
              expandedInsets: EdgeInsets.zero,
              initialSelection: drug.notificationType,
              controller: _methodController,
              // requestFocusOnTap: true,
              label: const Text('Напоминание'),
              onSelected: (type) {
                setState(() {
                  if (type != null) drug.notificationType = type;
                });
              },
              dropdownMenuEntries: NotificationType.values
                  .map(
                    (e) => DropdownMenuEntry(
                  value: e,
                  label: e.name,
                ),
              )
                  .toList(),
            ),
          ),
          Center(child: Text("Дни недели")),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: ToggleButtons(
                children: days.map((e) => Text(e)).toList(),
                isSelected: drug.consumptionDays,
                onPressed: (i) {
                  setState(() {
                    drug.consumptionDays[i] = !drug.consumptionDays[i];
                  });
                },
              ),),

          Center(child: Text("Время")),
          Expanded(
            child: ListView(
              children: drug.consumptionTimes.indexed.map((pair) {
                    final time = pair.$2;
                    final hours = time ~/ 60;
                    final minutes = time % 60;
                    return ListTile(
                      title: Text(
                          "${hours}:${minutes.toString().padLeft(2, "0")}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            drug.consumptionTimes.removeAt(pair.$1);
                          });
                        },
                      ),
                    );
                  }).toList() +
                  [
                    ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          final time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            final t = time.hour * 60 + time.minute;
                            setState(() {
                              drug.consumptionTimes.add(t);
                              drug.consumptionTimes.sort();
                            });
                          }
                        },
                      ),
                    ),
                  ],
            ),
          )
        ],
      ),
    );
  }
}
