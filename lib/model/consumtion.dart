import 'package:dart_mappable/dart_mappable.dart';
import 'package:pills/model/drug.dart';
import 'package:pills/repo/abstract_repo.dart';

part 'consumtion.mapper.dart';

@MappableClass()
class Consumption with ConsumptionMappable implements WithId{
  @override
  int id;
  DateTime time;
  Drug drug;
  String? image;

  Consumption({this.id=0, required this.time, required this.drug, this.image});
}