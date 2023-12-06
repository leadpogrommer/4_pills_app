import 'package:flutter/material.dart';
import 'package:pills/pages/drug_editor.dart';
import 'package:pills/repo/drug_repo.dart';

import 'model/drug.dart';

Future<void> main() async {
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
      ),
      body: StreamBuilder<Map<int, Drug>>(
          initialData: const {},
          stream: drugRepo.stream,
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data!.values.map((e) => ListTile(
                title: Text(e.name),
                onTap: () async {
                  final drug = await Navigator.of(context).push(DrugEditorRoute("Edit drug", drug: e));
                  if (drug != null){
                    drugRepo.saveDrug(drug);
                  }
                },
              )).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>addDrug(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void addDrug(BuildContext context) async {
    final drug = await Navigator.of(context).push(DrugEditorRoute("Add drug"));
    if (drug != null){
      drugRepo.addDrug(drug);
    }
  }
}
