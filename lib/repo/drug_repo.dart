import 'dart:async';

import 'package:pills/model/drug.dart';

final drugRepo = DrugRepo();


class DrugRepo{
  final Map<int, Drug> _drugs = {};
  int nextId = 1;
  final _controller = StreamController<Map<int, Drug>>();
  late final Stream<Map<int, Drug>> stream;

  DrugRepo(){
    stream = _controller.stream.asBroadcastStream();
  }

  int addDrug(Drug drug){
    drug.id = nextId++;
    _drugs[drug.id] = drug;
    _notify();
    return drug.id;
  }

  void saveDrug(Drug drug){
    // TODO: actually save int to storage
    _drugs[drug.id] = drug;
    _notify();
  }

  List<Drug> getDrugs() => List.from(_drugs.values);
  Drug? getDrug(int i) => _drugs[i];


  void _notify(){
    _controller.add(_drugs);
  }
}