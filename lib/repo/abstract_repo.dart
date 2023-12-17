import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/sheduler.dart';

abstract interface class WithId{
  late int id;
  String toJson();
}

class AbstractRepo<T extends WithId>{
  late final SharedPreferences prefs;
  int nextId = 1;
  bool inited = false;
  final String _prefix;
  final T Function(String) fromJson;

  final Map<int, T> _items = {};

  final _controller = BehaviorSubject<Map<int, T>>();
  late final Stream<Map<int, T>> stream = _controller.stream;

  AbstractRepo(this.fromJson, {required String prefix}) : _prefix = prefix;
  String _itemKey(T item) => "$_prefix${item.id}";

  Future<void> init() async {
    if(inited){
      return;
    }
    prefs = await SharedPreferences.getInstance();
    final itemIter = prefs.getKeys().where((element) => element.startsWith(_prefix)).map((e) => fromJson(prefs.getString(e)!)).map((e) => MapEntry(e.id, e));
    _items.addEntries(itemIter);
    nextId = _items.isNotEmpty ? _items.values.map((e) => e.id).reduce(max) + 1 : 1;
    inited = true;
    _notify();
  }


  Future<int> addItem(T item) async {
    item.id = nextId++;
    _items[item.id] = item;
    await prefs.setString(_itemKey(item), item.toJson());
    _notify();
    scheduler.schedule();
    return item.id;
  }

  void saveItem(T drug) async {
    // TODO: actually save int to storage
    _items[drug.id] = drug;
    await prefs.setString(_itemKey(drug), drug.toJson());
    scheduler.schedule();
    _notify();
  }

  List<T> getItems() => List.from(_items.values);
  T? getItem(int i) => _items[i];


  void _notify(){
    _controller.add(_items);
  }
}
