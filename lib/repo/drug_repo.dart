import 'dart:async';
import 'dart:math';

import 'package:pills/model/drug.dart';
import 'package:pills/repo/consumption_repo.dart';
import 'package:pills/service/sheduler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abstract_repo.dart';

final drugRepo = DrugRepo._();
const _drugPrefPrefix = "leadp.drug.";

String drugKey(Drug drug) => "$_drugPrefPrefix${drug.id}";

class DrugRepo extends AbstractRepo<Drug> {
  DrugRepo._()
      : super(
          DrugMapper.fromJson,
          prefix: _drugPrefPrefix,
        ) {}
}
