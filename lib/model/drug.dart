import 'package:dart_mappable/dart_mappable.dart';
import 'package:pills/repo/consumption_repo.dart';

import '../repo/abstract_repo.dart';

part 'drug.mapper.dart';

@MappableEnum()
enum NotificationType {
  push('Уведомление'), call('Звонок');

  final String name;

  const NotificationType(this.name);
}

@MappableClass()
class Drug with DrugMappable implements WithId {
  @override
  int id;
  String name;
  String notes;
  NotificationType notificationType;
  late List<int> consumptionTimes;
  late List<bool> consumptionDays;

  Drug({
    this.id = 0,
    this.name = "",
    this.notes = "",
    this.notificationType = NotificationType.push,
    List<int>? consumptionTimes,
    List<bool>? consumptionDays,
  }) {
    this.consumptionTimes = consumptionTimes ?? [];
    this.consumptionDays = consumptionDays ?? List.filled(7, false);
  }

  Drug reallyCopy(){
    return DrugMapper.fromMap(toMap());
  }
}
