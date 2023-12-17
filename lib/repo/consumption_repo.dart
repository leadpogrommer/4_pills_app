

import 'dart:math';

import 'package:pills/model/consumtion.dart';
import 'package:pills/repo/abstract_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/sheduler.dart';

const _consPrefPrefix = "leadp.consumption.";
final consumptionRepo = ConsumptionRepo._();

class ConsumptionRepo extends AbstractRepo<Consumption>{
  ConsumptionRepo._(): super(ConsumptionMapper.fromJson, prefix: _consPrefPrefix);
}

