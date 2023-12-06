enum NotificationType { push, call }

class Drug {
  int id;
  String name;
  NotificationType notificationType;
  List<int> consumptionTimes;
  late List<bool> consumptionDays;

  Drug(
    this.name, {
    this.notificationType = NotificationType.push,
    this.consumptionTimes = const [],
    List<bool>? consumptionDays = null,
        this.id = 0,
  }){
    if(consumptionDays == null){
      this.consumptionDays = [false, false, false, false, false, false, false];
    }else{
      this.consumptionDays = consumptionDays;
    }
  }

  Drug copy() => Drug(
        name,
        notificationType: notificationType,
        consumptionTimes: consumptionTimes.toList(),
        consumptionDays: consumptionDays.toList(),
        id: id,
      );
}
