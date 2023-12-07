import 'package:dart_mappable/dart_mappable.dart';

part 'drug.mapper.dart';

@MappableEnum()
enum NotificationType { push, call }

@MappableClass()
class Drug with DrugMappable {
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
