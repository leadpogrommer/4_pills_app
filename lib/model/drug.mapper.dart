// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'drug.dart';

class NotificationTypeMapper extends EnumMapper<NotificationType> {
  NotificationTypeMapper._();

  static NotificationTypeMapper? _instance;
  static NotificationTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationTypeMapper._());
    }
    return _instance!;
  }

  static NotificationType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NotificationType decode(dynamic value) {
    switch (value) {
      case 'push':
        return NotificationType.push;
      case 'call':
        return NotificationType.call;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NotificationType self) {
    switch (self) {
      case NotificationType.push:
        return 'push';
      case NotificationType.call:
        return 'call';
    }
  }
}

extension NotificationTypeMapperExtension on NotificationType {
  String toValue() {
    NotificationTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NotificationType>(this) as String;
  }
}

class DrugMapper extends ClassMapperBase<Drug> {
  DrugMapper._();

  static DrugMapper? _instance;
  static DrugMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DrugMapper._());
      NotificationTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Drug';

  static int _$id(Drug v) => v.id;
  static const Field<Drug, int> _f$id = Field('id', _$id, opt: true, def: 0);
  static String _$name(Drug v) => v.name;
  static const Field<Drug, String> _f$name =
      Field('name', _$name, opt: true, def: "");
  static String _$notes(Drug v) => v.notes;
  static const Field<Drug, String> _f$notes =
      Field('notes', _$notes, opt: true, def: "");
  static NotificationType _$notificationType(Drug v) => v.notificationType;
  static const Field<Drug, NotificationType> _f$notificationType = Field(
      'notificationType', _$notificationType,
      opt: true, def: NotificationType.push);
  static List<int> _$consumptionTimes(Drug v) => v.consumptionTimes;
  static const Field<Drug, List<int>> _f$consumptionTimes =
      Field('consumptionTimes', _$consumptionTimes, opt: true);
  static List<bool> _$consumptionDays(Drug v) => v.consumptionDays;
  static const Field<Drug, List<bool>> _f$consumptionDays =
      Field('consumptionDays', _$consumptionDays, opt: true);

  @override
  final Map<Symbol, Field<Drug, dynamic>> fields = const {
    #id: _f$id,
    #name: _f$name,
    #notes: _f$notes,
    #notificationType: _f$notificationType,
    #consumptionTimes: _f$consumptionTimes,
    #consumptionDays: _f$consumptionDays,
  };

  static Drug _instantiate(DecodingData data) {
    return Drug(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        notes: data.dec(_f$notes),
        notificationType: data.dec(_f$notificationType),
        consumptionTimes: data.dec(_f$consumptionTimes),
        consumptionDays: data.dec(_f$consumptionDays));
  }

  @override
  final Function instantiate = _instantiate;

  static Drug fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Drug>(map);
  }

  static Drug fromJson(String json) {
    return ensureInitialized().decodeJson<Drug>(json);
  }
}

mixin DrugMappable {
  String toJson() {
    return DrugMapper.ensureInitialized().encodeJson<Drug>(this as Drug);
  }

  Map<String, dynamic> toMap() {
    return DrugMapper.ensureInitialized().encodeMap<Drug>(this as Drug);
  }

  DrugCopyWith<Drug, Drug, Drug> get copyWith =>
      _DrugCopyWithImpl(this as Drug, $identity, $identity);
  @override
  String toString() {
    return DrugMapper.ensureInitialized().stringifyValue(this as Drug);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            DrugMapper.ensureInitialized().isValueEqual(this as Drug, other));
  }

  @override
  int get hashCode {
    return DrugMapper.ensureInitialized().hashValue(this as Drug);
  }
}

extension DrugValueCopy<$R, $Out> on ObjectCopyWith<$R, Drug, $Out> {
  DrugCopyWith<$R, Drug, $Out> get $asDrug =>
      $base.as((v, t, t2) => _DrugCopyWithImpl(v, t, t2));
}

abstract class DrugCopyWith<$R, $In extends Drug, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get consumptionTimes;
  ListCopyWith<$R, bool, ObjectCopyWith<$R, bool, bool>> get consumptionDays;
  $R call(
      {int? id,
      String? name,
      String? notes,
      NotificationType? notificationType,
      List<int>? consumptionTimes,
      List<bool>? consumptionDays});
  DrugCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DrugCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Drug, $Out>
    implements DrugCopyWith<$R, Drug, $Out> {
  _DrugCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Drug> $mapper = DrugMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get consumptionTimes =>
      ListCopyWith(
          $value.consumptionTimes,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(consumptionTimes: v));
  @override
  ListCopyWith<$R, bool, ObjectCopyWith<$R, bool, bool>> get consumptionDays =>
      ListCopyWith(
          $value.consumptionDays,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(consumptionDays: v));
  @override
  $R call(
          {int? id,
          String? name,
          String? notes,
          NotificationType? notificationType,
          Object? consumptionTimes = $none,
          Object? consumptionDays = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (notes != null) #notes: notes,
        if (notificationType != null) #notificationType: notificationType,
        if (consumptionTimes != $none) #consumptionTimes: consumptionTimes,
        if (consumptionDays != $none) #consumptionDays: consumptionDays
      }));
  @override
  Drug $make(CopyWithData data) => Drug(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      notes: data.get(#notes, or: $value.notes),
      notificationType:
          data.get(#notificationType, or: $value.notificationType),
      consumptionTimes:
          data.get(#consumptionTimes, or: $value.consumptionTimes),
      consumptionDays: data.get(#consumptionDays, or: $value.consumptionDays));

  @override
  DrugCopyWith<$R2, Drug, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DrugCopyWithImpl($value, $cast, t);
}
