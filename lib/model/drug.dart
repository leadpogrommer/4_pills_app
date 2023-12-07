enum NotificationType { push, call }

class Drug {
  int id;
  String name;
  String notes;
  NotificationType notificationType;
  late List<int> consumptionTimes;
  late List<bool> consumptionDays;

  Drug(
    this.name, {
      this.notes = "",
    this.notificationType = NotificationType.push,
    List<int>? consumptionTimes,
    List<bool>? consumptionDays,
        this.id = 0,
  }){
    if(consumptionDays == null){
      this.consumptionDays = [false, false, false, false, false, false, false];
    }else{
      this.consumptionDays = consumptionDays;
    }

    if(consumptionTimes == null){
      this.consumptionTimes = [];
    }else{
      this.consumptionTimes = consumptionTimes;
    }
  }

  Drug copy() => Drug(
        name,
        notificationType: notificationType,
        consumptionTimes: consumptionTimes.toList(),
        consumptionDays: consumptionDays.toList(),
        id: id,
    notes: notes,
      );
}
