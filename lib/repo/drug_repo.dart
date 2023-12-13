import 'dart:async';
import 'dart:math';

import 'package:pills/model/drug.dart';
import 'package:pills/service/sheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final drugRepo = DrugRepo();
const _drugPrefPrefix = "leadp.drug.";

String drugKey(Drug drug) => "$_drugPrefPrefix${drug.id}";

class DrugRepo{
  late final SharedPreferences prefs;
  bool inited = false;
  final Map<int, Drug> _drugs = {};
  int nextId = 1;
  final _controller = StreamController<Map<int, Drug>>();
  late final Stream<Map<int, Drug>> stream;

  DrugRepo(){
    stream = _controller.stream.asBroadcastStream();
  }

  Future<void> init() async {
    if(inited){
      return;
    }
    prefs = await SharedPreferences.getInstance();
    final drugIter = prefs.getKeys().where((element) => element.startsWith(_drugPrefPrefix)).map((e) => DrugMapper.fromJson(prefs.getString(e)!)).map((e) => MapEntry(e.id, e));
    _drugs.addEntries(drugIter);
    nextId = _drugs.isNotEmpty ? _drugs.values.map((e) => e.id).reduce(max) + 1 : 1;
    inited = true;
    _notify();
  }


  Future<int> addDrug(Drug drug) async {
    drug.id = nextId++;
    _drugs[drug.id] = drug;
    await prefs.setString(drugKey(drug), drug.toJson());
    _notify();
    scheduler.schedule();
    return drug.id;
  }

  void saveDrug(Drug drug) async {
    // TODO: actually save int to storage
    _drugs[drug.id] = drug;
    await prefs.setString(drugKey(drug), drug.toJson());
    scheduler.schedule();
    _notify();
  }

  List<Drug> getDrugs() => List.from(_drugs.values);
  Drug? getDrug(int i) => _drugs[i];


  void _notify(){
    _controller.add(_drugs);
  }
}