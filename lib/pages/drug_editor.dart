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
  static const days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];

  @override
  void initState() {
    super.initState();
    drug = widget.drug != null ? widget.drug!.copy() : Drug("");
    _nameController = TextEditingController(text: drug.name);
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
          Center(child: Text("Дни недели")),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: ToggleButtons(
              children: days.map((e) => Text(e)).toList(),
              isSelected: drug.consumptionDays,
              onPressed: (i){
                setState(() {
                  drug.consumptionDays[i] = !drug.consumptionDays[i];
                });
              },
            )
          ),
          Text("Потом здесь можно будет выбрать время приема", style: TextStyle(fontSize: 33),)
        ],
      ),
    );
  }
}
