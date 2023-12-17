// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'consumtion.dart';

class ConsumptionMapper extends ClassMapperBase<Consumption> {
  ConsumptionMapper._();

  static ConsumptionMapper? _instance;
  static ConsumptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConsumptionMapper._());
      DrugMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Consumption';

  static int _$id(Consumption v) => v.id;
  static const Field<Consumption, int> _f$id =
      Field('id', _$id, opt: true, def: 0);
  static DateTime _$time(Consumption v) => v.time;
  static const Field<Consumption, DateTime> _f$time = Field('time', _$time);
  static Drug _$drug(Consumption v) => v.drug;
  static const Field<Consumption, Drug> _f$drug = Field('drug', _$drug);
  static String? _$image(Consumption v) => v.image;
  static const Field<Consumption, String> _f$image =
      Field('image', _$image, opt: true);

  @override
  final Map<Symbol, Field<Consumption, dynamic>> fields = const {
    #id: _f$id,
    #time: _f$time,
    #drug: _f$drug,
    #image: _f$image,
  };

  static Consumption _instantiate(DecodingData data) {
    return Consumption(
        id: data.dec(_f$id),
        time: data.dec(_f$time),
        drug: data.dec(_f$drug),
        image: data.dec(_f$image));
  }

  @override
  final Function instantiate = _instantiate;

  static Consumption fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Consumption>(map);
  }

  static Consumption fromJson(String json) {
    return ensureInitialized().decodeJson<Consumption>(json);
  }
}

mixin ConsumptionMappable {
  String toJson() {
    return ConsumptionMapper.ensureInitialized()
        .encodeJson<Consumption>(this as Consumption);
  }

  Map<String, dynamic> toMap() {
    return ConsumptionMapper.ensureInitialized()
        .encodeMap<Consumption>(this as Consumption);
  }

  ConsumptionCopyWith<Consumption, Consumption, Consumption> get copyWith =>
      _ConsumptionCopyWithImpl(this as Consumption, $identity, $identity);
  @override
  String toString() {
    return ConsumptionMapper.ensureInitialized()
        .stringifyValue(this as Consumption);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ConsumptionMapper.ensureInitialized()
                .isValueEqual(this as Consumption, other));
  }

  @override
  int get hashCode {
    return ConsumptionMapper.ensureInitialized().hashValue(this as Consumption);
  }
}

extension ConsumptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Consumption, $Out> {
  ConsumptionCopyWith<$R, Consumption, $Out> get $asConsumption =>
      $base.as((v, t, t2) => _ConsumptionCopyWithImpl(v, t, t2));
}

abstract class ConsumptionCopyWith<$R, $In extends Consumption, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  DrugCopyWith<$R, Drug, Drug> get drug;
  $R call({int? id, DateTime? time, Drug? drug, String? image});
  ConsumptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ConsumptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Consumption, $Out>
    implements ConsumptionCopyWith<$R, Consumption, $Out> {
  _ConsumptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Consumption> $mapper =
      ConsumptionMapper.ensureInitialized();
  @override
  DrugCopyWith<$R, Drug, Drug> get drug =>
      $value.drug.copyWith.$chain((v) => call(drug: v));
  @override
  $R call({int? id, DateTime? time, Drug? drug, Object? image = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (time != null) #time: time,
        if (drug != null) #drug: drug,
        if (image != $none) #image: image
      }));
  @override
  Consumption $make(CopyWithData data) => Consumption(
      id: data.get(#id, or: $value.id),
      time: data.get(#time, or: $value.time),
      drug: data.get(#drug, or: $value.drug),
      image: data.get(#image, or: $value.image));

  @override
  ConsumptionCopyWith<$R2, Consumption, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ConsumptionCopyWithImpl($value, $cast, t);
}
